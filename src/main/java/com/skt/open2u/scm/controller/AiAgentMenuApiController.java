package com.skt.open2u.scm.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.skt.open2u.scm.service.AiAgentMenuService;

/**
 * SCM AI Agent 메뉴 API — EPRO DB 스냅샷·이벤트.
 * 운영 등 *.do 디스패처 환경에 맞춰 URL을 .do 로 제공한다.
 */
@Controller
public class AiAgentMenuApiController {

    private static final Logger log = LoggerFactory.getLogger(AiAgentMenuApiController.class);

    /** JSON 배열·객체 모두 @RequestBody 로 받기 위해 (Map 바인딩과 달리 배열 루트 허용) */
    private static final ObjectMapper SAVE_BODY_MAPPER = new ObjectMapper();

    @Autowired
    private AiAgentMenuService aiAgentMenuService;

    @RequestMapping(value = "/AiAgentMenuGet.do", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<?> getMenus(@RequestParam("section") String section) {
        try {
            JsonNode data = aiAgentMenuService.loadMenuJson(section.toUpperCase());
            return ResponseEntity.ok(data);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg(e.getMessage()));
        } catch (Exception e) {
            log.error("메뉴 조회 실패 section={}", section, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg("메뉴 조회 중 오류가 발생했습니다."));
        }
    }

    @RequestMapping(value = "/AiAgentMenuSave.do", method = { RequestMethod.PUT, RequestMethod.POST })
    @ResponseBody
    public ResponseEntity<?> putMenus(
            @RequestParam("section") String section,
            @RequestBody JsonNode body,
            HttpServletRequest request) {
        try {
            String actor = resolveActor(request);
            String bodyJson = SAVE_BODY_MAPPER.writeValueAsString(body);
            aiAgentMenuService.saveMenuAndLogEvents(section.toUpperCase(), bodyJson, actor);
            Map<String, Object> ok = new HashMap<String, Object>();
            ok.put("ok", Boolean.TRUE);
            return ResponseEntity.ok(ok);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg(e.getMessage()));
        } catch (Exception e) {
            Throwable root = unwrap(e);
            log.error(
                    "메뉴 저장 실패 section={} message={}",
                    section,
                    root != null ? root.getMessage() : e.getMessage(),
                    e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(msg("메뉴 저장 중 오류: " + (root != null ? root.getMessage() : e.getMessage())));
        }
    }

    @RequestMapping(value = "/AiAgentMenuEvents.do", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<?> getEvents(
            @RequestParam("section") String section, @RequestParam(value = "limit", defaultValue = "50") int limit) {
        try {
            List<Map<String, Object>> rows = aiAgentMenuService.loadEvents(section.toUpperCase(), limit);
            return ResponseEntity.ok(rows);
        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(msg(e.getMessage()));
        } catch (Exception e) {
            log.error("이벤트 조회 실패 section={}", section, e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(msg("이벤트 조회 중 오류가 발생했습니다."));
        }
    }

    private static String resolveActor(HttpServletRequest request) {
        String h = request.getHeader("X-Actor-Id");
        if (h != null && !h.trim().isEmpty()) {
            return h.trim();
        }
        String ru = request.getRemoteUser();
        if (ru != null && !ru.trim().isEmpty()) {
            return ru.trim();
        }
        return "";
    }

    private static Map<String, String> msg(String text) {
        Map<String, String> m = new HashMap<String, String>();
        m.put("message", text);
        return m;
    }

    private static Throwable unwrap(Throwable e) {
        Throwable c = e;
        while (c != null && c.getCause() != null && c.getCause() != c) {
            c = c.getCause();
        }
        return c;
    }
}
