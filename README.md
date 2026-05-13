# Karpathy-Inspired Claude Code Guidelines

> Check out my new project [Multica](https://github.com/multica-ai/multica) — an open-source platform for running and managing coding agents with reusable skills.
>
> Follow me on X: [https://x.com/jiayuan_jy](https://x.com/jiayuan_jy)

A single `CLAUDE.md` file to improve Claude Code behavior, derived from [Andrej Karpathy's observations](https://x.com/karpathy/status/2015883857489522876) on LLM coding pitfalls.

English | [简体中文](./README.zh.md)

## The Problems

From Andrej's post:

> "The models make wrong assumptions on your behalf and just run along with them without checking. They don't manage their confusion, don't seek clarifications, don't surface inconsistencies, don't present tradeoffs, don't push back when they should."

> "They really like to overcomplicate code and APIs, bloat abstractions, don't clean up dead code... implement a bloated construction over 1000 lines when 100 would do."

> "They still sometimes change/remove comments and code they don't sufficiently understand as side effects, even if orthogonal to the task."

## The Solution

Four principles in one file that directly address these issues:

| Principle | Addresses |
|-----------|-----------|
| **Think Before Coding** | Wrong assumptions, hidden confusion, missing tradeoffs |
| **Simplicity First** | Overcomplication, bloated abstractions |
| **Surgical Changes** | Orthogonal edits, touching code you shouldn't |
| **Goal-Driven Execution** | Leverage through tests-first, verifiable success criteria |

## The Four Principles in Detail

### 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

LLMs often pick an interpretation silently and run with it. This principle forces explicit reasoning:

- **State assumptions explicitly** — If uncertain, ask rather than guess
- **Present multiple interpretations** — Don't pick silently when ambiguity exists
- **Push back when warranted** — If a simpler approach exists, say so
- **Stop when confused** — Name what's unclear and ask for clarification

### 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

Combat the tendency toward overengineering:

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

### 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it

When your changes create orphans:

- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace directly to the user's request.

### 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform imperative tasks into verifiable goals:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |

For multi-step tasks, state a brief plan:

```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let the LLM loop independently. Weak criteria ("make it work") require constant clarification.

## Install

**Option A: Claude Code Plugin (recommended)**

From within Claude Code, first add the marketplace:
```
/plugin marketplace add forrestchang/andrej-karpathy-skills
```

Then install the plugin:
```
/plugin install andrej-karpathy-skills@karpathy-skills
```

This installs the guidelines as a Claude Code plugin, making the skill available across all your projects.

**Option B: CLAUDE.md (per-project)**

New project:
```bash
curl -o CLAUDE.md https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md
```

Existing project (append):
```bash
echo "" >> CLAUDE.md
curl https://raw.githubusercontent.com/forrestchang/andrej-karpathy-skills/main/CLAUDE.md >> CLAUDE.md
```

## Using with Cursor

This repository includes a committed Cursor project rule ([`.cursor/rules/karpathy-guidelines.mdc`](.cursor/rules/karpathy-guidelines.mdc)) so the same guidelines apply when you open the project in Cursor. See **[CURSOR.md](CURSOR.md)** for setup, using the rule in other projects, and how this relates to Claude Code.

## Key Insight

From Andrej:

> "LLMs are exceptionally good at looping until they meet specific goals... Don't tell it what to do, give it success criteria and watch it go."

The "Goal-Driven Execution" principle captures this: transform imperative instructions into declarative goals with verification loops.

## How to Know It's Working

These guidelines are working if you see:

- **Fewer unnecessary changes in diffs** — Only requested changes appear
- **Fewer rewrites due to overcomplication** — Code is simple the first time
- **Clarifying questions come before implementation** — Not after mistakes
- **Clean, minimal PRs** — No drive-by refactoring or "improvements"

## Customization

These guidelines are designed to be merged with project-specific instructions. Add them to your existing `CLAUDE.md` or create a new one.

For project-specific rules, add sections like:

```markdown
## Project-Specific Guidelines

- Use TypeScript strict mode
- All API endpoints must have tests
- Follow the existing error handling patterns in `src/utils/errors.ts`
```

## Tradeoff Note

These guidelines bias toward **caution over speed**. For trivial tasks (simple typo fixes, obvious one-liners), use judgment — not every change needs the full rigor.

The goal is reducing costly mistakes on non-trivial work, not slowing down simple tasks.

## License

MIT

# Open2U (Spring Framework 4.1 / 비부트, Maven WAR)

본 저장소는 Spring Boot가 아닌 **Spring Framework 4.1** 기반의 전통적인 Maven WAR 웹 애플리케이션 스캐폴드입니다. as-is 레거시 코드를 동일 스택으로 이관·운영하기 위한 골격을 제공합니다.

본 문서가 **단일 진실 공급원(Single Source of Truth)** 입니다. 별도의 `docs/TECH-SPEC.md`를 두지 않으며, Cursor 프로젝트 스킬 [.cursor/skills/open2u-legacy-webapp/SKILL.md](.cursor/skills/open2u-legacy-webapp/SKILL.md) 가 이 README를 참조합니다.

> 작업 규칙: 이 저장소를 다루는 모든 프롬프트/에이전트 작업은 변경 전에 본 README의 1~8장을 우선 확인하고, 본 README의 디렉터리 규약·버전 핀·디자이너 산출물 워크플로(6장)를 위반하지 않는다.

---

## 1. 기술 스택 / 버전 표 (고정값)


| 영역          | 선택                                                                       | 비고                                                                 |
| ----------- | ------------------------------------------------------------------------ | ------------------------------------------------------------------ |
| 언어          | Java **8** (source/target = 1.8)                                         | Spring 4.1과 호환되는 최저 권장 버전                                          |
| 프레임워크       | Spring Framework **4.1.9.RELEASE**                                       | Spring Boot 미사용, XML 기반 구성                                         |
| 세션/모바일 (선택) | spring-session **1.3.0.RELEASE**, spring-mobile-device **1.1.4.RELEASE** | 레거시 정합용 (필요 시 활성)                                                  |
| 빌드          | Maven, `packaging` = **war**                                             | Maven 3.6+ 권장                                                      |
| 뷰           | **JSP** + **JSTL 1.2** + **Apache Tiles 3.0.x**                          | `src/main/webapp/WEB-INF/jsp`, `src/main/resources/META-INF/tiles` |
| 영속          | **MyBatis 3.4.x** + **mybatis-spring 1.3.x**                             | `src/main/resources/META-INF/persistence.mybatis`                  |
| DB          | **MySQL 8.0**                                                            | 드라이버 `mysql-connector-j` 8.x                                       |
| 커넥션 풀       | HikariCP 2.7.x (Java 8 호환 라인)                                            | properties로 분리                                                     |
| 로깅          | **Logback 1.2.x** + slf4j 1.7.x                                          | `src/main/resources/logback.xml`                                   |
| 프론트 정적      | 자체 양식 CSS + **jQuery**                                                   | `src/main/webapp/resource/{css,js,images,font,lib}` (단수 `resource`, 디자이너 산출물 표준 경로) |
| 패키지 루트      | `**com.skt.open2u`**                                                     | 요청의 `skt.open2u`는 관례상 `com` 접두                                     |


> 버전을 임의로 올리지 마십시오. as-is와 동일한 라이브러리 라인을 유지하는 것이 본 프로젝트의 1순위 제약입니다.
> 예외: `org.aspectj:aspectjweaver`/`aspectjrt`는 as-is 이미지에 명시되지 않은 의존성이며, JDK 17+ 환경의 zip 검증 문제로 **1.9.7**로 사용합니다 (Java 8 호환 라인). Spring 4.1.9·spring-aspects 4.1.9와 호환됩니다.

---

## 2. 디렉터리 규약

```
open2u/
├── pom.xml
├── README.md                       # 본 문서 (기술 스펙 + 빌드/실행 가이드)
├── .cursor/
│   └── skills/
│       └── open2u-legacy-webapp/
│           └── SKILL.md            # 프로젝트 전용 Cursor 스킬
└── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── skt/open2u/             # 패키지 루트
        │           └── web/                # MVC 컨트롤러
        ├── resources/
        │   ├── META-INF/
        │   │   ├── messages/               # i18n 메시지 번들
        │   │   ├── persistence.mybatis/    # MyBatis 설정 + Mapper XML
        │   │   ├── properties/             # 외부 properties (jdbc 등)
        │   │   ├── spring/                 # Spring XML 설정 모음
        │   │   └── tiles/                  # Tiles definitions
        │   └── logback.xml                 # 로깅 설정
        └── webapp/
            ├── html/                        # 디자이너 퍼블리싱 산출물 (참고용; 라우팅 대상 아님)
            │   ├── main/                    # 메인 화면 (main_내부.html 등)
            │   └── ...                      # 업무별 폴더 (계약관리, 검사조서, 공급사 등)
            ├── resource/                    # 디자이너 정적 자원 (CSS/JS/이미지/폰트/라이브러리)
            │   ├── css/                     # 자체 양식 CSS (jquery-ui, ui.common, alopex3, ...)
            │   ├── js/                      # 자체 스크립트 (ui.common.js 등)
            │   ├── images/                  # 이미지/아이콘 (svg, png)
            │   ├── font/                    # Pretendard 등 웹폰트
            │   └── lib/                     # jQuery, Alopex, Swiper, mCustomScrollbar 등 서드파티
            └── WEB-INF/
                ├── jsp/                     # JSP 뷰 (디자이너 HTML을 JSP로 변환해 위치)
                ├── layouts/                 # Tiles 레이아웃 (모듈화된 페이지용)
                └── web.xml
```

> 위 트리는 신규 프로젝트 **초기 골격**입니다. 이미지의 as-is 디렉터리(예: `src/main/java/com/adt/skcc/common/ws/`, `src/main/resources/log4jdbc.log4j2.properties`, `src/main/resources/META-INF/{codes,common}`, `src/main/webapp/{common,EarContent,in,KICA_SGIxLinker,template}`, `src/main/webapp/resource/{bestbp,font,images,include,lib,plugin}` 등)는 **as-is 이관 시점**에 7장 절차에 따라 추가합니다.

---

## 3. 데이터베이스 (MySQL 8.0)

JDBC 설정은 `src/main/resources/META-INF/properties/jdbc.properties`에 둡니다. **비밀번호 등 민감 값은 환경변수 또는 외부 properties로 주입**하고, 저장소에 평문으로 커밋하지 않습니다.

권장 기본값:


| 항목                     | 값                                                                                                                                           |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `jdbc.driverClassName` | `com.mysql.cj.jdbc.Driver`                                                                                                                  |
| `jdbc.url`             | `jdbc:mysql://<host>:3306/<db>?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Seoul&useSSL=false&allowPublicKeyRetrieval=true` |
| `jdbc.username`        | (외부 주입)                                                                                                                                     |
| `jdbc.password`        | (외부 주입)                                                                                                                                     |
| 풀                      | HikariCP, `maximumPoolSize=10` 등 환경에 맞춰 조정                                                                                                  |


MyBatis 설정:

- 글로벌 설정: `src/main/resources/META-INF/persistence.mybatis/mybatis-config.xml`
- Mapper XML: `src/main/resources/META-INF/persistence.mybatis/mappers/*.xml`
- Mapper 인터페이스: `com.skt.open2u.**.mapper`

---

## 4. 빌드 / 실행

요구 사항: Maven 3.6+, JDK 8 (또는 `--release 8` 컴파일 가능한 상위 JDK).

```bash
mvn clean package
```

산출물: `target/open2u.war`. 외부 톰캣 8.5/9.x에 배포하거나, 로컬 검증 시 다음을 사용할 수 있습니다.

```bash
# 의존성 트리 확인 (버전 고정 검증)
mvn -q dependency:tree

# 컴파일만 확인
mvn -q -DskipTests compile
```

WAR 컨텍스트 패스는 톰캣 배포 정책에 따릅니다. 로컬에서는 `ROOT.war`로 배치하면 루트 컨텍스트(`/`)에서 동작합니다.

### 로컬 실행 (개발용, 임베디드 Jetty)

zero-config 로컬 기동은 `jetty-maven-plugin`을 통해 가능합니다. JDK 17 권장 (Jetty 9.4 공식 지원 라인). JDK 25에서도 일반적으로 기동되나 비공식입니다.

```bash
# (선택) JDK 17 사용
export JAVA_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null || echo $JAVA_HOME)

# 기동 (포그라운드) — Ctrl+C 로 종료
mvn -DskipTests jetty:run

# 또는 백그라운드 기동 + 중지
mvn -DskipTests jetty:run &        # 백그라운드
mvn jetty:stop                     # 중지 (stopKey=open2u, stopPort=18081 사용)
```

접속: <http://localhost:8080/> 또는 <http://localhost:8080/home> → Open2U Hello 페이지.

---

## 5. 핵심 설정 파일 인덱스

- 빌드: [pom.xml](pom.xml)
- 서블릿 디스크립터: [src/main/webapp/WEB-INF/web.xml](src/main/webapp/WEB-INF/web.xml)
- Spring 루트 컨텍스트: [src/main/resources/META-INF/spring/applicationContext.xml](src/main/resources/META-INF/spring/applicationContext.xml)
- DispatcherServlet 컨텍스트: [src/main/resources/META-INF/spring/dispatcher-servlet.xml](src/main/resources/META-INF/spring/dispatcher-servlet.xml)
- 영속(MyBatis): [src/main/resources/META-INF/spring/persistence-context.xml](src/main/resources/META-INF/spring/persistence-context.xml), [src/main/resources/META-INF/persistence.mybatis/mybatis-config.xml](src/main/resources/META-INF/persistence.mybatis/mybatis-config.xml)
- Tiles: [src/main/resources/META-INF/tiles/tiles-definitions.xml](src/main/resources/META-INF/tiles/tiles-definitions.xml)
- 로깅: [src/main/resources/logback.xml](src/main/resources/logback.xml)
- 외부 설정: [src/main/resources/META-INF/properties/jdbc.properties](src/main/resources/META-INF/properties/jdbc.properties)

---

## 6. 디자이너 산출물 → JSP 워크플로

본 프로젝트의 화면은 사내 디자이너가 `src/main/webapp/html/**` 에 퍼블리싱한 HTML을 **단일 소스**로 한다. 모든 화면 작업은 다음 절차를 따른다.

1. 디자이너 산출물 확인: `src/main/webapp/html/<업무>/<파일>.html` 을 그대로 브라우저로 열어 디자인을 확인한다. 이 파일들은 **편집 금지**(디자이너 영역).
2. JSP 변환:
   - 대상 JSP는 `src/main/webapp/WEB-INF/jsp/` 하위에 둔다.
   - 파일 상단에 다음 prologue를 추가한다:
     ```
     <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
     <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
     <c:set var="ctx" value="${pageContext.request.contextPath}"/>
     ```
   - HTML의 상대경로 `../../resource/...` 를 모두 `${ctx}/resource/...` 로 치환한다.
   - DOM 구조·CSS 클래스·텍스트는 디자이너 원본을 그대로 유지한다. 가공이 필요하면 별도 partial JSP / Tiles attribute로 분리한다.
3. 라우팅: `com.skt.open2u.web.<XxxController>` 에 `@Controller` + `@RequestMapping` 으로 view 이름을 반환한다. view 이름은 `home` 처럼 Tiles 정의 이름이 없으면 `InternalResourceViewResolver` 가 `/WEB-INF/jsp/<이름>.jsp` 를 찾는다.
4. Tiles 사용 시: 모듈형 페이지(메인 외 다수 화면)는 `src/main/resources/META-INF/tiles/tiles-definitions.xml` 의 `base.definition` 을 확장한다. 메인처럼 디자이너가 풀페이지(헤더/푸터 포함)로 만들어준 화면은 Tiles 정의를 만들지 않는다.
5. 정적 자원: 모든 CSS/JS/이미지/폰트/라이브러리는 `src/main/webapp/resource/` (단수) 아래만 사용한다. Spring MVC 매핑은 `<mvc:resources mapping="/resource/**" location="/resource/"/>`.

---

## 7. as-is 이관(마이그레이션) 절차

초기 골격에는 아래 레거시 디렉터리·파일을 **두지 않습니다**. as-is 코드를 반영하는 시점에만 동일 경로에 복사·생성합니다.

추가 대상 (필요 시):

- `src/main/java/com/adt/skcc/common/ws/**`
- `src/main/resources/log4jdbc.log4j2.properties`
- `src/main/resources/META-INF/{codes,common}/**`
- `src/main/webapp/{common,EarContent,in,KICA_SGIxLinker,template}/**`

이관 순서:

1. as-is 저장소에서 본 저장소의 동일 경로에 복사합니다.
   - `src/main/java/com/skt/open2u/**`, 위 "추가 대상" 중 필요한 것
   - `src/main/resources/META-INF/{messages,persistence.mybatis,properties,spring,tiles}/**`
   - `src/main/webapp/WEB-INF/{jsp,layouts}/**`, `src/main/webapp/resource/**`
2. **버전을 절대로 올리지 마십시오.** as-is `WEB-INF/lib`의 JAR 목록과 [pom.xml](pom.xml) 의존성 버전을 한 줄 한 줄 대조하여 일치시킵니다 (spring-* 4.1.9, spring-session 1.3.0, spring-mobile-device 1.1.4 등).
3. XML 네임스페이스 / 스키마 버전을 4.1 라인으로 통일합니다 (`spring-beans-4.1.xsd` 등).
4. DispatcherServlet `contextConfigLocation` 경로와 필터 매핑이 본 스캐폴드와 일치하도록 web.xml을 정합합니다.
5. 로컬 MySQL 8.0 인스턴스에 as-is 스키마를 적용한 뒤 `mvn -q dependency:tree`로 의존성 충돌을 점검하고, 톰캣에 배포해 화면 1개 이상 렌더링되는지 확인합니다.

---

## 8. 운영 규칙 (에이전트·개발자 공통)

- 새 파일을 만들 때는 본 README 2장의 디렉터리 규약을 따른다. 임의 위치 생성 금지.
- 의존성 추가 시 본 README 1장 “버전 표”와 [pom.xml](pom.xml) 의 기존 버전 라인을 깨지 않는다.
- Spring Boot 의존성(starter-* 등) 도입 금지. 본 프로젝트는 비부트 스택이다.
- 로깅은 SLF4J + Logback 만 사용한다 (commons-logging / log4j 1.x 의존 추가 금지).
- 정적 리소스는 `src/main/webapp/resource/` (단수) 하위 디렉터리를 사용한다.

