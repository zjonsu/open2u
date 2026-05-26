package com.skt.open2u.scm.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

/**
 * SCM AI Agent 메뉴 스냅샷·이벤트 (메인 dataSource / transactionManager 와 동일 풀 사용).
 */
@Repository("aiAgentMenuEproDAO")
public class AiAgentMenuEproDAO {

    private static final String NS = "adm.AiAgentMenuEproDAO.";

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

    public String selectSnapshotJson(String sectionCd) {
        return sqlSessionTemplate.selectOne(NS + "selectSnapshotJson", sectionCd);
    }

    public void upsertSnapshot(String sectionCd, String menuJson) {
        Map<String, Object> p = new HashMap<String, Object>();
        p.put("sectionCd", sectionCd);
        p.put("menuJson", menuJson);
        sqlSessionTemplate.insert(NS + "upsertSnapshot", p);
    }

    public void insertEvent(
            String sectionCd,
            String eventTyp,
            String moduleId,
            String linkId,
            String oldJson,
            String newJson,
            String actorId) {
        Map<String, Object> p = new HashMap<String, Object>();
        p.put("sectionCd", sectionCd);
        p.put("eventTyp", eventTyp);
        p.put("moduleId", moduleId);
        p.put("linkId", linkId);
        p.put("oldJson", oldJson);
        p.put("newJson", newJson);
        p.put("actorId", actorId);
        sqlSessionTemplate.insert(NS + "insertEvent", p);
    }

    public List<Map<String, Object>> selectEventList(String sectionCd, int limit) {
        Map<String, Object> p = new HashMap<String, Object>();
        p.put("sectionCd", sectionCd);
        p.put("limit", limit);
        return sqlSessionTemplate.selectList(NS + "selectEventList", p);
    }
}
