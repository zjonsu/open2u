package com.skt.open2u.scm.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.skt.open2u.scm.dao.AiAgentMenuEproDAO;

/**
 * SCM / PILOT AI Agent 메뉴 스냅샷 저장 및 변경 이벤트(모듈·링크 CRUD) 기록.
 */
@Service("aiAgentMenuService")
public class AiAgentMenuService {

    private static final Logger log = LoggerFactory.getLogger(AiAgentMenuService.class);

    public static final String EVENT_MODULE_ADD = "MODULE_ADD";
    public static final String EVENT_MODULE_EDIT = "MODULE_EDIT";
    public static final String EVENT_MODULE_DEL = "MODULE_DEL";
    public static final String EVENT_LINK_ADD = "LINK_ADD";
    public static final String EVENT_LINK_EDIT = "LINK_EDIT";
    public static final String EVENT_LINK_DEL = "LINK_DEL";

    private static final int JSON_CAP = 3900;

    /** 운영 등에서 루트 XML에 ObjectMapper 빈을 두지 않아도 동작하도록 로컬 인스턴스 사용 */
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Autowired
    private AiAgentMenuEproDAO aiAgentMenuEproDAO;

    public JsonNode loadMenuJson(String sectionCd) throws Exception {
        assertSection(sectionCd);
        String raw = aiAgentMenuEproDAO.selectSnapshotJson(sectionCd);
        if (raw == null || raw.trim().isEmpty()) {
            return OBJECT_MAPPER.createArrayNode();
        }
        JsonNode n = OBJECT_MAPPER.readTree(raw);
        return n.isArray() ? n : OBJECT_MAPPER.createArrayNode();
    }

    public List<Map<String, Object>> loadEvents(String sectionCd, int limit) throws Exception {
        assertSection(sectionCd);
        int lim = limit <= 0 ? 50 : Math.min(limit, 500);
        List<Map<String, Object>> rows = aiAgentMenuEproDAO.selectEventList(sectionCd, lim);
        return rows != null ? rows : Collections.emptyList();
    }

    @Transactional
    public void saveMenuAndLogEvents(String sectionCd, String requestBody, String actorId) throws Exception {
        assertSection(sectionCd);
        final JsonNode newTree = OBJECT_MAPPER.readTree(requestBody);
        if (!newTree.isArray()) {
            throw new IllegalArgumentException("메뉴 본문은 JSON 배열이어야 합니다.");
        }
        final ArrayNode newArr = (ArrayNode) newTree;
        ensureModuleAndLinkIds(newArr);

        final String actor = actorId != null ? actorId : "";
        final String normalizedNew = OBJECT_MAPPER.writeValueAsString(newArr);

        String oldRaw = aiAgentMenuEproDAO.selectSnapshotJson(sectionCd);
        ArrayNode oldArr = OBJECT_MAPPER.createArrayNode();
        if (oldRaw != null && !oldRaw.trim().isEmpty()) {
            JsonNode parsed = OBJECT_MAPPER.readTree(oldRaw);
            if (parsed.isArray()) {
                oldArr = (ArrayNode) parsed;
            }
        }
        ensureModuleAndLinkIds(oldArr);
        appendDiffEvents(sectionCd, oldArr, newArr, actor);
        aiAgentMenuEproDAO.upsertSnapshot(sectionCd, normalizedNew);
    }

    private static void assertSection(String sectionCd) {
        if (!"SCM".equals(sectionCd) && !"PILOT".equals(sectionCd)) {
            throw new IllegalArgumentException("section은 SCM 또는 PILOT 만 허용됩니다.");
        }
    }

    private void ensureModuleAndLinkIds(ArrayNode modules) {
        for (int i = 0; i < modules.size(); i++) {
            JsonNode m = modules.get(i);
            if (!m.isObject()) {
                continue;
            }
            ObjectNode mo = (ObjectNode) m;
            if (!mo.hasNonNull("moduleId") || mo.path("moduleId").asText("").trim().isEmpty()) {
                mo.put("moduleId", UUID.randomUUID().toString());
            }
            JsonNode links = mo.path("links");
            if (links.isArray()) {
                ArrayNode la = (ArrayNode) links;
                for (int j = 0; j < la.size(); j++) {
                    JsonNode ln = la.get(j);
                    if (!ln.isObject()) {
                        continue;
                    }
                    ObjectNode lo = (ObjectNode) ln;
                    if (!lo.hasNonNull("linkId") || lo.path("linkId").asText("").trim().isEmpty()) {
                        lo.put("linkId", UUID.randomUUID().toString());
                    }
                }
            }
        }
    }

    private void appendDiffEvents(String sectionCd, ArrayNode oldArr, ArrayNode newArr, String actorId) {
        List<JsonNode> oldMods = toModuleList(oldArr);
        List<JsonNode> newMods = toModuleList(newArr);

        boolean[] oldUsed = new boolean[oldMods.size()];
        boolean[] newUsed = new boolean[newMods.size()];

        List<int[]> idMatches = new ArrayList<int[]>();
        for (int oi = 0; oi < oldMods.size(); oi++) {
            if (oldUsed[oi]) {
                continue;
            }
            String oid = moduleIdOf(oldMods.get(oi));
            if (oid == null) {
                continue;
            }
            for (int ni = 0; ni < newMods.size(); ni++) {
                if (newUsed[ni]) {
                    continue;
                }
                String nid = moduleIdOf(newMods.get(ni));
                if (oid.equals(nid)) {
                    idMatches.add(new int[] { oi, ni });
                    oldUsed[oi] = true;
                    newUsed[ni] = true;
                    break;
                }
            }
        }

        int niCursor = 0;
        for (int oi = 0; oi < oldMods.size(); oi++) {
            if (oldUsed[oi]) {
                continue;
            }
            while (niCursor < newMods.size() && newUsed[niCursor]) {
                niCursor++;
            }
            if (niCursor >= newMods.size()) {
                break;
            }
            idMatches.add(new int[] { oi, niCursor });
            oldUsed[oi] = true;
            newUsed[niCursor] = true;
            niCursor++;
        }

        for (int ni = 0; ni < newMods.size(); ni++) {
            if (!newUsed[ni]) {
                insertEvent(
                        sectionCd,
                        EVENT_MODULE_ADD,
                        moduleIdOf(newMods.get(ni)),
                        null,
                        null,
                        capJson(newMods.get(ni)),
                        actorId);
            }
        }
        for (int oi = 0; oi < oldMods.size(); oi++) {
            if (!oldUsed[oi]) {
                insertEvent(
                        sectionCd,
                        EVENT_MODULE_DEL,
                        moduleIdOf(oldMods.get(oi)),
                        null,
                        capJson(oldMods.get(oi)),
                        null,
                        actorId);
            }
        }

        for (int[] pair : idMatches) {
            JsonNode om = oldMods.get(pair[0]);
            JsonNode nm = newMods.get(pair[1]);
            String mid = moduleIdOf(nm);
            if (mid == null) {
                continue;
            }
            String oldTitle = text(om, "title");
            String newTitle = text(nm, "title");
            boolean oldFeat = om.path("featured").asBoolean(false);
            boolean newFeat = nm.path("featured").asBoolean(false);
            if (!oldTitle.equals(newTitle) || oldFeat != newFeat) {
                ObjectNode oj = OBJECT_MAPPER.createObjectNode();
                oj.put("title", oldTitle);
                oj.put("featured", oldFeat);
                ObjectNode nj = OBJECT_MAPPER.createObjectNode();
                nj.put("title", newTitle);
                nj.put("featured", newFeat);
                insertEvent(
                        sectionCd,
                        EVENT_MODULE_EDIT,
                        mid,
                        null,
                        capJson(oj),
                        capJson(nj),
                        actorId);
            }
            diffLinks(sectionCd, mid, om.path("links"), nm.path("links"), actorId);
        }
    }

    private void diffLinks(String sectionCd, String moduleId, JsonNode oldLinks, JsonNode newLinks, String actorId) {
        List<JsonNode> oldL = toLinkList(oldLinks);
        List<JsonNode> newL = toLinkList(newLinks);
        boolean[] ou = new boolean[oldL.size()];
        boolean[] nu = new boolean[newL.size()];

        List<int[]> pairs = new ArrayList<int[]>();
        for (int oi = 0; oi < oldL.size(); oi++) {
            if (ou[oi]) {
                continue;
            }
            String oid = linkIdOf(oldL.get(oi));
            if (oid == null) {
                continue;
            }
            for (int ni = 0; ni < newL.size(); ni++) {
                if (nu[ni]) {
                    continue;
                }
                String nid = linkIdOf(newL.get(ni));
                if (oid.equals(nid)) {
                    pairs.add(new int[] { oi, ni });
                    ou[oi] = true;
                    nu[ni] = true;
                    break;
                }
            }
        }
        int nic = 0;
        for (int oi = 0; oi < oldL.size(); oi++) {
            if (ou[oi]) {
                continue;
            }
            while (nic < newL.size() && nu[nic]) {
                nic++;
            }
            if (nic >= newL.size()) {
                break;
            }
            pairs.add(new int[] { oi, nic });
            ou[oi] = true;
            nu[nic] = true;
            nic++;
        }

        for (int ni = 0; ni < newL.size(); ni++) {
            if (!nu[ni]) {
                insertEvent(
                        sectionCd,
                        EVENT_LINK_ADD,
                        moduleId,
                        linkIdOf(newL.get(ni)),
                        null,
                        capJson(newL.get(ni)),
                        actorId);
            }
        }
        for (int oi = 0; oi < oldL.size(); oi++) {
            if (!ou[oi]) {
                insertEvent(
                        sectionCd,
                        EVENT_LINK_DEL,
                        moduleId,
                        linkIdOf(oldL.get(oi)),
                        capJson(oldL.get(oi)),
                        null,
                        actorId);
            }
        }
        for (int[] pr : pairs) {
            JsonNode ol = oldL.get(pr[0]);
            JsonNode nl = newL.get(pr[1]);
            String lid = linkIdOf(nl);
            if (lid == null) {
                continue;
            }
            String oLabel = text(ol, "label");
            String nLabel = text(nl, "label");
            String oHref = text(ol, "href");
            String nHref = text(nl, "href");
            if (!oLabel.equals(nLabel) || !oHref.equals(nHref)) {
                ObjectNode oj = OBJECT_MAPPER.createObjectNode();
                oj.put("label", oLabel);
                oj.put("href", oHref);
                ObjectNode nj = OBJECT_MAPPER.createObjectNode();
                nj.put("label", nLabel);
                nj.put("href", nHref);
                insertEvent(
                        sectionCd,
                        EVENT_LINK_EDIT,
                        moduleId,
                        lid,
                        capJson(oj),
                        capJson(nj),
                        actorId);
            }
        }
    }

    private void insertEvent(
            String sectionCd,
            String eventTyp,
            String moduleId,
            String linkId,
            String oldJson,
            String newJson,
            String actorId) {
        aiAgentMenuEproDAO.insertEvent(sectionCd, eventTyp, moduleId, linkId, oldJson, newJson, actorId);
    }

    private String capJson(JsonNode node) {
        try {
            String s = OBJECT_MAPPER.writeValueAsString(node);
            if (s.length() <= JSON_CAP) {
                return s;
            }
            return s.substring(0, JSON_CAP);
        } catch (Exception e) {
            log.warn("JSON 직렬화 실패, 이벤트 필드 생략", e);
            return null;
        }
    }

    private static List<JsonNode> toModuleList(ArrayNode arr) {
        List<JsonNode> out = new ArrayList<JsonNode>();
        for (int i = 0; i < arr.size(); i++) {
            JsonNode n = arr.get(i);
            if (n.isObject()) {
                out.add(n);
            }
        }
        return out;
    }

    private static List<JsonNode> toLinkList(JsonNode links) {
        List<JsonNode> out = new ArrayList<JsonNode>();
        if (!links.isArray()) {
            return out;
        }
        ArrayNode arr = (ArrayNode) links;
        for (int i = 0; i < arr.size(); i++) {
            JsonNode n = arr.get(i);
            if (n.isObject()) {
                out.add(n);
            }
        }
        return out;
    }

    private static String moduleIdOf(JsonNode m) {
        if (m == null || !m.isObject()) {
            return null;
        }
        String id = m.path("moduleId").asText("").trim();
        return id.isEmpty() ? null : id;
    }

    private static String linkIdOf(JsonNode m) {
        if (m == null || !m.isObject()) {
            return null;
        }
        String id = m.path("linkId").asText("").trim();
        return id.isEmpty() ? null : id;
    }

    private static String text(JsonNode m, String field) {
        if (m == null) {
            return "";
        }
        return m.path(field).asText("").trim();
    }
}
