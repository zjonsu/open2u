package com.skt.open2u.scm.config;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.DatabasePopulatorUtils;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.stereotype.Component;

/**
 * 기동 시 AI Agent 메뉴 스냅샷·이벤트 테이블을 확인한다.
 * {@code CREATE TABLE IF NOT EXISTS} 이므로 재기동마다 안전하게 실행된다.
 */
@Component
public class AiAgentMenuSchemaInitializer implements InitializingBean {

    private static final Logger log = LoggerFactory.getLogger(AiAgentMenuSchemaInitializer.class);

    private static final String DDL_CLASSPATH = "META-INF/sql/epro/V1__ai_agent_menu.sql";

    @Autowired
    private DataSource dataSource;

    @Override
    public void afterPropertiesSet() {
        ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.addScript(new ClassPathResource(DDL_CLASSPATH));
        populator.setCommentPrefix("--");
        populator.setSeparator(";");
        try {
            DatabasePopulatorUtils.execute(populator, dataSource);
            log.info("AI Agent 메뉴 스키마 초기화 완료 ({})", DDL_CLASSPATH);
        } catch (Exception e) {
            log.error("AI Agent 메뉴 스키마 초기화 실패 — jdbc.url DB 연결 및 DDL 경로를 확인하세요.", e);
            throw new IllegalStateException("T_AI_AGENT_MENU_* 테이블을 생성하지 못했습니다.", e);
        }
    }
}
