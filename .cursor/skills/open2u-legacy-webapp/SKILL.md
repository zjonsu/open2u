---
name: open2u-legacy-webapp
description: Open2U legacy Spring Framework 4.1 (non-Boot) Maven WAR project conventions. Use whenever editing this repository, adding dependencies, creating Java/JSP/XML files under src/main, or discussing build/run/MyBatis/Tiles/Logback/jQuery setup for open2u (com.skt.open2u). Designer publishing HTML lives under src/main/webapp/html/** and static assets under src/main/webapp/resource/ (singular).
---

이 저장소의 단일 진실 공급원은 [README.md](../../../README.md) 입니다. 어떤 작업이든 먼저 README를 읽고 그 규약을 따르세요.

## Hard rules

- 모든 작업 전에 [README.md](../../../README.md) 1~8장을 확인한다 (디자이너 산출물 워크플로 포함).
- Spring Boot 의존성(starter-* 등) 도입 금지
- 버전 변경 금지 (spring 4.1.9, MyBatis 3.4.x, mysql-connector-j 8.x, logback 1.2.x)
- 패키지 루트는 `com.skt.open2u`
- JSP는 `src/main/webapp/WEB-INF/jsp`, Tiles 레이아웃은 `WEB-INF/layouts`
- 정적 자원은 src/main/webapp/resource/ (단수) 아래만 사용한다. mvc:resources 매핑은 /resource/** → /resource/.
- 디자이너 산출물(src/main/webapp/html/**)은 편집 금지(참고용). JSP로 옮길 때 ../../resource/... 경로는 ${pageContext.request.contextPath}/resource/... 로 변환한다.
- 로깅은 SLF4J + Logback만 (commons-logging / log4j 1.x 금지)
- Spring XML 네임스페이스는 4.1 라인
- 비밀번호 등 민감 값은 properties / 환경변수로 분리

자세한 사양·디렉터리 규약·이관 절차는 [README.md](../../../README.md) 1~8장을 참조하세요.

## 서버 레이어 (Controller / Service / DAO / MyBatis)

업무별 패키지(`com.skt.open2u.adm`, `cmn`, `pur` 등), 레이어 분리, MyBatis namespace·`RESULT_LIST` 관례, SLF4J 로깅, JSON API 시 Jackson, **신규 DB 테이블·컬럼·인덱스 등 객체 식별자 대문자 작명** 등은 **[open2u-server-architecture](../../rules/open2u-server-architecture.mdc)** 규칙을 따른다. `src/main/java` 및 `META-INF/persistence.mybatis` 작업 시 해당 규칙을 우선 적용한다.
