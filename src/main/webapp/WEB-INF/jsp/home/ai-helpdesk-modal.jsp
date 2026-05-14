<%@ page pageEncoding="UTF-8" %>
<style>
    #aiHelpDeskLayer .lay_pop_area {
        max-width: min(1180px, 96vw);
        width: 96%;
        box-sizing: border-box;
    }
    #aiHelpDeskLayer .lay_pop_cont {
        padding: 16px 20px 24px;
        max-height: calc(100vh - 120px);
        overflow: auto;
        background: #fff;
    }
    .ai-helpdesk-map {
        font-size: 13px;
        color: #2b2f3a;
        --ai-brand: #3617CE;
        --ai-brand-dark: #201267;
        --ai-surface: #f7f6fb;
        --ai-border: #d9d7e7;
        --ai-muted: #6b6f7e;
        --ai-card: #eef0f8;
        --ai-card-accent: #ebe7fb;
    }
    /* 상단 프로세스: 좌→우 브랜드 톤 그라데이션 화살표 + 노드 */
    .ai-helpdesk-map .ai-hd-phases {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        list-style: none;
        margin: 0 0 22px;
        padding: 0 20px 18px 12px;
        position: relative;
        box-sizing: border-box;
    }
    .ai-helpdesk-map .ai-hd-phases::before {
        content: '';
        position: absolute;
        left: 14px;
        right: 22px;
        top: calc(13px * 2.5 + 10px + 9px);
        height: 5px;
        border-radius: 3px 0 0 3px;
        background: linear-gradient(
            90deg,
            var(--ai-surface) 0%,
            var(--ai-card-accent) 22%,
            #c9bdf5 48%,
            #7c68e8 78%,
            var(--ai-brand) 100%
        );
        z-index: 0;
        pointer-events: none;
    }
    .ai-helpdesk-map .ai-hd-phases::after {
        content: '';
        position: absolute;
        right: 8px;
        top: calc(13px * 2.5 + 10px + 9px - 6px);
        width: 0;
        height: 0;
        border-style: solid;
        border-width: 8px 0 8px 14px;
        border-color: transparent transparent transparent var(--ai-brand-dark);
        z-index: 1;
        pointer-events: none;
    }
    .ai-helpdesk-map .ai-hd-phases > li {
        flex: 1;
        text-align: center;
        position: relative;
        z-index: 2;
        padding: 0 2px;
        min-width: 0;
    }
    .ai-helpdesk-map .ai-hd-phase-name {
        display: block;
        font-size: 13px;
        font-weight: 800;
        line-height: 1.25;
        margin-bottom: 10px;
        color: var(--ai-brand-dark);
        min-height: 2.5em;
    }
    .ai-helpdesk-map .ai-hd-phase-node {
        display: inline-block;
        width: 12px;
        height: 12px;
        border-radius: 50%;
        background: var(--ai-brand);
        border: 3px solid #e4defa;
        box-shadow: 0 0 0 1px rgba(54, 23, 206, 0.35);
        vertical-align: middle;
    }
    .ai-helpdesk-map .ai-hd-block {
        border: 2px dashed var(--ai-border);
        border-radius: 8px;
        padding: 10px 10px 12px 36px;
        margin-bottom: 12px;
        position: relative;
        background: var(--ai-surface);
    }
    .ai-helpdesk-map .ai-hd-block-label {
        position: absolute;
        left: 0;
        top: 0;
        bottom: 0;
        width: 28px;
        writing-mode: vertical-rl;
        text-orientation: mixed;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 800;
        font-size: 11px;
        letter-spacing: 0.18em;
        background: linear-gradient(180deg, #2a2170, var(--ai-brand-dark));
        color: #f2f1f8;
        border-radius: 6px 0 0 6px;
        border-right: 1px solid var(--ai-border);
    }
    .ai-helpdesk-map .ai-hd-cols {
        display: grid;
        grid-template-columns: repeat(6, minmax(0, 1fr));
        gap: 8px;
    }
    .ai-helpdesk-map .ai-hd-col {
        display: flex;
        flex-direction: column;
        gap: 8px;
        min-width: 0;
    }
    .ai-helpdesk-map .ai-hd-card {
        border-radius: 8px;
        overflow: visible;
        border: none;
        background: transparent;
        box-shadow: none;
    }
    /* 대분류 타이틀: gray/featured 배경은 :not(:hover) 로만 적용 → 호버 시 단일 규칙이 항상 이김 (순서·이중 클래스와 무관) */
    .ai-helpdesk-map .ai-hd-card-head {
        position: relative;
        padding: 10px 12px;
        font-size: 13px;
        font-weight: 700;
        border-radius: 5px 16px;
        background: #fff;
        border: 2px solid #D2D0E1;
        color: #201267;
        margin-bottom: 8px;
        box-sizing: border-box;
        cursor: default;
        transition: background-color 0.2s ease, border-color 0.2s ease, color 0.2s ease;
    }
    .ai-helpdesk-map .ai-hd-card--featured .ai-hd-card-head {
        padding-left: 24px;
    }
    .ai-helpdesk-map .ai-hd-card--featured .ai-hd-card-head:not(:hover) {
        background: linear-gradient(180deg, #faf9ff 0%, #fff 100%);
        color: #201267;
    }
    .ai-helpdesk-map .ai-hd-card--gray .ai-hd-card-head:not(:hover) {
        background: #fff;
        color: #201267;
    }
    .ai-helpdesk-map .ai-hd-card-head:hover {
        background-color: #3617CE;
        border-color: #3617CE;
        color: #fff;
    }
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pilot-title {
        color: #fff;
    }
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pilot-rename-module,
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pilot-del-module {
        color: rgba(255, 255, 255, 0.9);
    }
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pilot-rename-module:hover {
        color: #fff;
    }
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pilot-del-module:hover {
        color: #ffcdd2;
    }
    .ai-helpdesk-map .ai-hd-card-head:hover .ai-hd-pin {
        background: #fff;
        border: 1px solid rgba(255, 255, 255, 0.5);
        box-shadow: none;
    }
    .ai-helpdesk-map .ai-hd-pin {
        position: absolute;
        left: 8px;
        top: 50%;
        width: 10px;
        height: 10px;
        background: var(--ai-brand);
        border-radius: 50% 50% 50% 0;
        transform: translateY(-50%) rotate(-45deg);
        box-shadow: 0 1px 2px rgba(32, 18, 103, 0.25);
    }
    /* 타이틀(구매계획 AI 등) 아래 서브메뉴 — 회색 스택/대형 박스 없이 목록형 */
    .ai-helpdesk-map .ai-hd-card ul {
        list-style: none;
        margin: 4px 0 0;
        padding: 0 0 0 6px;
        background: transparent;
        border-left: 2px solid #e8e6f2;
    }
    .ai-helpdesk-map .ai-hd-card ul li {
        margin: 0;
        padding: 0;
        position: relative;
        line-height: 1.4;
    }
    .ai-helpdesk-map .ai-hd-card ul li::before {
        content: none;
        display: none;
    }
    .ai-helpdesk-map .ai-hd-card ul li > a {
        display: block;
        position: relative;
        box-sizing: border-box;
        min-height: 0;
        margin: 0;
        padding: 8px 30px 8px 8px;
        border: none;
        border-radius: 4px;
        background-color: transparent;
        color: #201267;
        font-size: 13px;
        font-weight: 600;
        line-height: 1.4;
        text-decoration: none;
        word-break: keep-all;
        transition: background-color 0.15s, color 0.15s;
    }
    .ai-helpdesk-map .ai-hd-card ul li > a::before {
        content: none;
        display: none;
    }
    .ai-helpdesk-map .ai-hd-card ul li > a::after {
        content: '';
        position: absolute;
        top: 50%;
        right: 6px;
        transform: translateY(-50%);
        width: 22px;
        height: 10px;
        opacity: 0.45;
        background: url('${pageContext.request.contextPath}/resource/images/new_common/ico_main_banner.svg') no-repeat center;
        background-size: 100% auto;
        pointer-events: none;
        transition: opacity 0.15s;
    }
    /* 하위 링크: 호버 시 배경/강조 효과 없음 */
    .ai-helpdesk-map .ai-hd-card ul li > a:hover {
        background-color: transparent;
        color: #201267;
        text-decoration: none;
    }
    .ai-helpdesk-map .ai-hd-card ul li > a:hover::after {
        opacity: 0.45;
    }
    .ai-helpdesk-map .ai-hd-pilot .ai-hd-card ul,
    .ai-helpdesk-map .ai-hd-scm .ai-hd-card ul {
        padding-top: 0;
    }
    .ai-helpdesk-map .ai-hd-scm-inner {
        width: 100%;
        min-width: 0;
    }
    .ai-helpdesk-map .ai-hd-scm .ai-hd-card-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        padding-right: 8px;
    }
    .ai-helpdesk-map .ai-hd-pilot-inner {
        width: 100%;
        min-width: 0;
    }
    .ai-helpdesk-map .ai-hd-pilot-toolbar {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        margin-bottom: 10px;
    }
    .ai-helpdesk-map .ai-hd-toolbar-actions {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        flex-shrink: 0;
    }
    .ai-helpdesk-map .ai-hd-btn-gear {
        width: 32px;
        height: 32px;
        border-radius: 4px;
        border: 1px solid var(--ai-border);
        background: #fff;
        color: var(--ai-brand-dark);
        cursor: pointer;
        font-size: 18px;
        line-height: 1;
        padding: 0;
        flex-shrink: 0;
    }
    .ai-helpdesk-map .ai-hd-btn-gear:hover {
        border-color: var(--ai-brand);
        color: var(--ai-brand);
    }
    #aiHelpDeskLayer.ai-hd-edit-mode-on .ai-hd-btn-gear {
        background: var(--ai-brand);
        color: #fff;
        border-color: var(--ai-brand);
    }
    /* 관리자 + 편집 모드 꺼짐: 추가·수정·삭제 UI 숨김 (톱니바퀴만 노출) */
    #aiHelpDeskLayer:not(.ai-hd-edit-mode-on) .ai-hd-admin-editable {
        display: none !important;
    }
    .ai-helpdesk-map .ai-hd-pilot-hint {
        font-size: 12px;
        color: var(--ai-muted);
        line-height: 1.4;
    }
    .ai-helpdesk-map .ai-hd-pilot-btn-add {
        padding: 6px 12px;
        border-radius: 4px;
        border: 1px solid var(--ai-brand);
        background: #f5f3fc;
        color: var(--ai-brand);
        font-size: 12px;
        font-weight: 600;
        cursor: pointer;
        white-space: nowrap;
    }
    .ai-helpdesk-map .ai-hd-pilot-btn-add:hover {
        background: var(--ai-brand);
        color: #fff;
    }
    .ai-helpdesk-map .ai-hd-pilot-cols {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
        gap: 8px;
        align-items: start;
    }
    .ai-helpdesk-map .ai-hd-pilot .ai-hd-card-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 8px;
        padding-right: 8px;
    }
    .ai-helpdesk-map .ai-hd-pilot-title {
        flex: 1;
        min-width: 0;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
    }
    .ai-helpdesk-map .ai-hd-pilot-del-module {
        flex: 0 0 auto;
        border: none;
        background: transparent;
        color: #9a97b0;
        font-size: 20px;
        line-height: 1;
        cursor: pointer;
        padding: 0 2px;
    }
    .ai-helpdesk-map .ai-hd-pilot-del-module:hover {
        color: #c62828;
    }
    .ai-helpdesk-map .ai-hd-pilot-card-foot {
        padding: 6px 8px 8px;
        border-top: 1px solid #ecebf4;
        background: #fafafa;
    }
    .ai-helpdesk-map .ai-hd-pilot-add-link {
        padding: 4px 10px;
        font-size: 11px;
        font-weight: 600;
        border: 1px dashed #c4bddc;
        background: #fff;
        color: var(--ai-brand);
        border-radius: 4px;
        cursor: pointer;
    }
    .ai-helpdesk-map .ai-hd-pilot-add-link:hover {
        border-color: var(--ai-brand);
        background: #f5f3fc;
    }
    .ai-helpdesk-map .ai-hd-pilot-ul li.ai-hd-pilot-li {
        display: flex;
        align-items: center;
        gap: 6px;
        margin: 0 0 4px;
        padding: 0;
    }
    .ai-helpdesk-map .ai-hd-pilot-ul li.ai-hd-pilot-li > a {
        flex: 1;
        min-width: 0;
    }
    .ai-helpdesk-map .ai-hd-pilot-ul li > a::after {
        display: none;
    }
    .ai-helpdesk-map .ai-hd-pilot-del-link {
        flex: 0 0 22px;
        width: 22px;
        height: 22px;
        border: none;
        background: transparent;
        color: #b0adca;
        font-size: 16px;
        line-height: 1;
        cursor: pointer;
        padding: 0;
    }
    .ai-helpdesk-map .ai-hd-pilot-del-link:hover {
        color: #c62828;
    }
    .ai-helpdesk-map .ai-hd-pilot-rename-module,
    .ai-helpdesk-map .ai-hd-pilot-rename-link {
        flex: 0 0 22px;
        width: 22px;
        height: 22px;
        border: none;
        background: transparent;
        color: #9a97b0;
        font-size: 13px;
        line-height: 1;
        cursor: pointer;
        padding: 0;
    }
    .ai-helpdesk-map .ai-hd-pilot-rename-module:hover,
    .ai-helpdesk-map .ai-hd-pilot-rename-link:hover {
        color: var(--ai-brand);
    }
    #aiPilotDetailLayer.lay_pop_wrap {
        z-index: 2100;
    }
    #aiPilotDetailLayer .lay_pop_area {
        max-width: min(520px, 94vw);
    }
    .ai-pilot-detail-desc {
        margin: 0;
        font-size: 14px;
        color: #444;
        line-height: 1.55;
    }
    .ai-pilot-detail-url {
        margin: 12px 0 0;
        font-size: 12px;
        color: #666;
        word-break: break-all;
    }
</style>
<div id="aiHelpDeskLayer" class="lay_pop_wrap" aria-hidden="true">
    <div class="lay_pop_bg"></div>
    <div class="lay_pop_area">
        <div class="lay_pop_head">
            <div class="lay_pop_title"><h2>SCM AI Agent 메뉴</h2></div>
            <button type="button" class="lay_pop_close" title="닫기" aria-label="닫기"></button>
        </div>
        <div class="lay_pop_cont ai-helpdesk-map">

            <ol class="ai-hd-phases" aria-label="프로세스 단계">
                <li><span class="ai-hd-phase-name">사전 지원</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
                <li><span class="ai-hd-phase-name">Resource<br>Planning</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
                <li><span class="ai-hd-phase-name">계약수행/<br>관리</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
                <li><span class="ai-hd-phase-name">정산 관리</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
                <li><span class="ai-hd-phase-name">구매 관리</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
                <li><span class="ai-hd-phase-name">동반성장</span><span class="ai-hd-phase-node" aria-hidden="true"></span></li>
            </ol>

            <section class="ai-hd-block ai-hd-scm" aria-label="SCM">
                <div class="ai-hd-block-label">SCM</div>
                <div class="ai-hd-scm-inner">
                    <div class="ai-hd-pilot-toolbar">
                        <span class="ai-hd-pilot-hint">SCM 모듈(타이틀 + 서브링크) 구성은 수시로 변경될 수 있습니다. PILOT에는 사용 빈도가 높은 메뉴가 추가될 수 있습니다.</span>
                        <c:if test="${aiHelpdeskAdmin}">
                        <div class="ai-hd-toolbar-actions">
                        <button type="button" id="aiScmAddModule" class="ai-hd-pilot-btn-add ai-hd-admin-editable">+ 모듈 추가</button>
                        <button type="button" class="ai-hd-btn-gear ai-hd-helpdesk-edit-toggle" title="편집 도구 켜기" aria-label="편집 도구 켜기" aria-pressed="false">&#9881;</button>
                        </div>
                        </c:if>
                    </div>
                    <div id="aiScmMenuCols" class="ai-hd-cols ai-hd-pilot-cols"></div>
                </div>
            </section>

            <section class="ai-hd-block ai-hd-pilot" aria-label="PILOT">
                <div class="ai-hd-block-label">PILOT</div>
                <div class="ai-hd-pilot-inner">
                    <div class="ai-hd-pilot-toolbar">
                        <span class="ai-hd-pilot-hint">모듈(타이틀 + 서브링크) 구성은 수시로 변경될 수 있습니다.</span>
                        <c:if test="${aiHelpdeskAdmin}">
                        <div class="ai-hd-toolbar-actions">
                        <button type="button" id="aiPilotAddModule" class="ai-hd-pilot-btn-add ai-hd-admin-editable">+ 모듈 추가</button>
                        <button type="button" class="ai-hd-btn-gear ai-hd-helpdesk-edit-toggle" title="편집 도구 켜기" aria-label="편집 도구 켜기" aria-pressed="false">&#9881;</button>
                        </div>
                        </c:if>
                    </div>
                    <div id="aiPilotMenuCols" class="ai-hd-cols ai-hd-pilot-cols"></div>
                </div>
            </section>

            <template id="aiPilotCardTpl">
                <div class="ai-hd-col">
                    <div class="ai-hd-card ai-hd-card--gray ai-hd-pilot-card">
                        <div class="ai-hd-card-head">
                            <span class="ai-hd-pilot-title">새 PILOT</span>
                            <c:if test="${aiHelpdeskAdmin}">
                            <button type="button" class="ai-hd-pilot-rename-module ai-hd-admin-editable" title="모듈명 변경" aria-label="모듈명 변경">&#9998;</button>
                            <button type="button" class="ai-hd-pilot-del-module ai-hd-admin-editable" aria-label="모듈 삭제">&times;</button>
                            </c:if>
                        </div>
                        <ul class="ai-hd-pilot-ul"></ul>
                        <c:if test="${aiHelpdeskAdmin}">
                        <div class="ai-hd-pilot-card-foot ai-hd-admin-editable">
                            <button type="button" class="ai-hd-pilot-add-link">+ 링크 추가</button>
                        </div>
                        </c:if>
                    </div>
                </div>
            </template>

            <template id="aiScmCardTpl">
                <div class="ai-hd-col">
                    <div class="ai-hd-card ai-hd-card--gray ai-hd-pilot-card">
                        <div class="ai-hd-card-head">
                            <span class="ai-hd-pilot-title">새 SCM</span>
                            <c:if test="${aiHelpdeskAdmin}">
                            <button type="button" class="ai-hd-pilot-rename-module ai-hd-admin-editable" title="모듈명 변경" aria-label="모듈명 변경">&#9998;</button>
                            <button type="button" class="ai-hd-pilot-del-module ai-hd-admin-editable" aria-label="모듈 삭제">&times;</button>
                            </c:if>
                        </div>
                        <ul class="ai-hd-pilot-ul"></ul>
                        <c:if test="${aiHelpdeskAdmin}">
                        <div class="ai-hd-pilot-card-foot ai-hd-admin-editable">
                            <button type="button" class="ai-hd-pilot-add-link">+ 링크 추가</button>
                        </div>
                        </c:if>
                    </div>
                </div>
            </template>

            <div id="aiPilotDetailLayer" class="lay_pop_wrap" aria-hidden="true">
                <div class="lay_pop_bg"></div>
                <div class="lay_pop_area" style="width: 480px">
                    <div class="lay_pop_head">
                        <div class="lay_pop_title"><h2 id="aiPilotDetailTitle">PILOT</h2></div>
                        <button type="button" class="lay_pop_close ai-pilot-detail-close" title="닫기" aria-label="닫기"></button>
                    </div>
                    <div class="lay_pop_cont">
                        <p id="aiPilotDetailDesc" class="ai-pilot-detail-desc"></p>
                        <p id="aiPilotDetailUrlRow" class="ai-pilot-detail-url" style="display: none"></p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<%-- AI Help Desk: 레이어 바인딩 · SCM/PILOT 메뉴 API 연동 (메인 페이지 스크립트와 분리) --%>
<script>
            (function () {
                function bindAiHelpDeskModal() {
                    var layer = document.getElementById('aiHelpDeskLayer');
                    var openBtn = document.getElementById('aiHelpDeskOpen');
                    if (!layer || !openBtn) return;

                    function resetHelpdeskEditMode() {
                        syncHelpdeskEditMode(false);
                    }

                    function syncHelpdeskEditMode(on) {
                        if (on) {
                            layer.classList.add('ai-hd-edit-mode-on');
                        } else {
                            layer.classList.remove('ai-hd-edit-mode-on');
                        }
                        layer.querySelectorAll('.ai-hd-helpdesk-edit-toggle').forEach(function (btn) {
                            btn.setAttribute('aria-pressed', on ? 'true' : 'false');
                            btn.setAttribute('title', on ? '편집 도구 끄기' : '편집 도구 켜기');
                            btn.setAttribute('aria-label', on ? '편집 도구 끄기' : '편집 도구 켜기');
                        });
                    }

                    if (window.OPEN2U_AI_HELPDESK_ADMIN) {
                        layer.querySelectorAll('.ai-hd-helpdesk-edit-toggle').forEach(function (btn) {
                            btn.addEventListener('click', function (e) {
                                e.preventDefault();
                                e.stopPropagation();
                                syncHelpdeskEditMode(!layer.classList.contains('ai-hd-edit-mode-on'));
                            });
                        });
                    }

                    openBtn.addEventListener('click', function (e) {
                        e.preventDefault();
                        layer.classList.add('active');
                        layer.setAttribute('aria-hidden', 'false');
                    });
                    var mainBg = layer.querySelector(':scope > .lay_pop_bg');
                    if (mainBg) {
                        mainBg.addEventListener('click', function () {
                            layer.classList.remove('active');
                            layer.setAttribute('aria-hidden', 'true');
                            resetHelpdeskEditMode();
                            if (window.OPEN2U_PILOT_MENU && window.OPEN2U_PILOT_MENU.closeDetail) {
                                window.OPEN2U_PILOT_MENU.closeDetail();
                            }
                        });
                    }
                    var mainCloseBtn = layer.querySelector(':scope > .lay_pop_area > .lay_pop_head .lay_pop_close');
                    if (mainCloseBtn) {
                        mainCloseBtn.addEventListener('click', function () {
                            layer.classList.remove('active');
                            layer.setAttribute('aria-hidden', 'true');
                            resetHelpdeskEditMode();
                            if (window.OPEN2U_PILOT_MENU && window.OPEN2U_PILOT_MENU.closeDetail) {
                                window.OPEN2U_PILOT_MENU.closeDetail();
                            }
                        });
                    }
                }
                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', bindAiHelpDeskModal);
                } else {
                    bindAiHelpDeskModal();
                }
            })();
            (function initNetifyAgentMenus() {
                var detailLayer = document.getElementById('aiPilotDetailLayer');
                var CTX =
                    typeof OPEN2U_APP_CTX === 'string'
                        ? OPEN2U_APP_CTX
                        : '${pageContext.request.contextPath}'.replace(/\/?$/, '');
                var persistTimers = {};
                function genModuleId() {
                    if (typeof crypto !== 'undefined' && crypto.randomUUID) {
                        return crypto.randomUUID();
                    }
                    return 'm' + Date.now() + '_' + Math.random().toString(36).slice(2, 11);
                }
                function genLinkId() {
                    if (typeof crypto !== 'undefined' && crypto.randomUUID) {
                        return crypto.randomUUID();
                    }
                    return 'l' + Date.now() + '_' + Math.random().toString(36).slice(2, 11);
                }
                function queuePersist(section) {
                    if (!window.OPEN2U_AI_HELPDESK_ADMIN) return;
                    var layer = document.getElementById('aiHelpDeskLayer');
                    if (!layer || !layer.classList.contains('ai-hd-edit-mode-on')) return;
                    clearTimeout(persistTimers[section]);
                    persistTimers[section] = setTimeout(function () {
                        var api = section === 'SCM' ? window.OPEN2U_SCM_MENU : window.OPEN2U_PILOT_MENU;
                        if (!api || typeof api.getData !== 'function') return;
                        var payload = api.getData();
                        fetch(CTX + '/AiAgentMenuSave.do?section=' + encodeURIComponent(section), {
                            method: 'POST',
                            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
                            body: JSON.stringify(payload)
                        })
                            .then(function (r) {
                                if (!r.ok) {
                                    return r.text().then(function (t) {
                                        throw new Error('HTTP ' + r.status + ' ' + (t || ''));
                                    });
                                }
                                return r.json();
                            })
                            .catch(function (e) {
                                console.error('메뉴 저장 실패', section, e);
                            });
                    }, 700);
                }

                function closeAgentDetailLayer() {
                    if (!detailLayer) return;
                    detailLayer.classList.remove('active');
                    detailLayer.setAttribute('aria-hidden', 'true');
                }

                function openAgentDetailLayer(title, urlHint, detailOpts) {
                    detailOpts = detailOpts || {};
                    if (!detailLayer) return;
                    var h2 = document.getElementById('aiPilotDetailTitle');
                    var desc = document.getElementById('aiPilotDetailDesc');
                    var urlRow = document.getElementById('aiPilotDetailUrlRow');
                    if (h2) h2.textContent = title || detailOpts.fallbackHeading || '메뉴';
                    if (desc) {
                        desc.textContent =
                            '선택한 ' +
                            (detailOpts.menuKindLabel || '메뉴') +
                            '입니다. 아래 주소가 있으면 새 창 또는 페이지로 이동하고, 없으면 이 안내 창만 표시합니다.';
                    }
                    if (urlRow) {
                        if (urlHint) {
                            urlRow.textContent = '연결 주소: ' + urlHint;
                            urlRow.style.display = 'block';
                        } else {
                            urlRow.textContent = '';
                            urlRow.style.display = 'none';
                        }
                    }
                    if (typeof detailOpts.onLinkOpen === 'function') {
                        detailOpts.onLinkOpen({ title: title || '', href: urlHint || '' });
                    }
                    detailLayer.classList.add('active');
                    detailLayer.setAttribute('aria-hidden', 'false');
                }

                if (detailLayer) {
                    detailLayer
                        .querySelectorAll('.lay_pop_bg, .ai-pilot-detail-close')
                        .forEach(function (el) {
                            el.addEventListener('click', closeAgentDetailLayer);
                        });
                }

                function applyCardVariant(col, cardOpts) {
                    cardOpts = cardOpts || {};
                    var card = col.querySelector('.ai-hd-card');
                    var head = col.querySelector('.ai-hd-card-head');
                    var titleEl = col.querySelector('.ai-hd-pilot-title');
                    if (!card || !head || !titleEl) return;
                    if (cardOpts.featured) {
                        card.classList.remove('ai-hd-card--gray');
                        card.classList.add('ai-hd-card--featured');
                        if (!head.querySelector('.ai-hd-pin')) {
                            var pin = document.createElement('span');
                            pin.className = 'ai-hd-pin';
                            pin.setAttribute('aria-hidden', 'true');
                            head.insertBefore(pin, titleEl);
                        }
                    } else {
                        card.classList.remove('ai-hd-card--featured');
                        card.classList.add('ai-hd-card--gray');
                        var existingPin = head.querySelector('.ai-hd-pin');
                        if (existingPin) existingPin.remove();
                    }
                }

                function createMenuController(opts) {
                    var root = document.getElementById(opts.rootId);
                    var tpl = document.getElementById(opts.templateId);
                    var addBtn = document.getElementById(opts.addBtnId);
                    if (!root || !tpl) return null;

                    var fireChanged = typeof opts.onChanged === 'function' ? opts.onChanged : function () {};

                    var modSeq = 0;
                    var defaultPrefix = opts.defaultModulePrefix || '모듈';
                    var menuKindLabel = opts.menuKindLabel || '메뉴';

                    function openDetailForLink(title, urlHint) {
                        openAgentDetailLayer(title, urlHint, {
                            menuKindLabel: menuKindLabel,
                            fallbackHeading: opts.fallbackDetailHeading || '메뉴',
                            onLinkOpen: opts.onLinkOpen
                        });
                    }

                    root.addEventListener('click', function (e) {
                        if (e.target.closest && e.target.closest('button')) return;
                        var a = e.target.closest && e.target.closest('.ai-hd-pilot-ul li.ai-hd-pilot-li > a');
                        if (!a) return;
                        e.preventDefault();
                        var raw = (a.getAttribute('data-pilot-href') || '').trim();
                        var title = (a.textContent || '').trim();
                        if (raw && (raw.indexOf('http://') === 0 || raw.indexOf('https://') === 0)) {
                            window.open(raw, '_blank', 'noopener,noreferrer');
                            return;
                        }
                        if (raw && raw.charAt(0) === '/' && raw.toLowerCase().indexOf('javascript:') !== 0) {
                            var ctx = typeof window.OPEN2U_CONTEXT_PATH === 'string' ? window.OPEN2U_CONTEXT_PATH : '';
                            var base = ctx.replace(/\/$/, '');
                            window.location.href = base + (raw.indexOf('/') === 0 ? raw : '/' + raw);
                            return;
                        }
                        openDetailForLink(title, raw);
                    });

                    function addLink(ul, label, hrefOpt, silent, linkIdOpt) {
                        if (typeof silent === 'undefined') silent = false;
                        var li = document.createElement('li');
                        li.className = 'ai-hd-pilot-li';
                        var lid =
                            linkIdOpt != null && String(linkIdOpt).trim()
                                ? String(linkIdOpt).trim()
                                : genLinkId();
                        li.setAttribute('data-link-id', lid);
                        var a = document.createElement('a');
                        a.href = 'javascript:;';
                        a.textContent = label || '링크';
                        var hrefRaw = hrefOpt != null ? String(hrefOpt).trim() : '';
                        if (hrefRaw) a.setAttribute('data-pilot-href', hrefRaw);
                        li.appendChild(a);
                        if (window.OPEN2U_AI_HELPDESK_ADMIN) {
                            var ed = document.createElement('button');
                            ed.type = 'button';
                            ed.className = 'ai-hd-pilot-rename-link ai-hd-admin-editable';
                            ed.setAttribute('aria-label', '링크명·주소 변경');
                            ed.textContent = '\u270E';
                            ed.addEventListener('click', function (ev) {
                                ev.preventDefault();
                                ev.stopPropagation();
                                var nt =
                                    typeof window.prompt === 'function'
                                        ? window.prompt('링크 이름', a.textContent.trim())
                                        : null;
                                if (nt === null) return;
                                a.textContent = String(nt).trim() || a.textContent;
                                var nu =
                                    typeof window.prompt === 'function'
                                        ? window.prompt(
                                              '링크 주소 (http(s)://… 또는 /path, 비우면 클릭 시 안내 팝업)',
                                              a.getAttribute('data-pilot-href') || ''
                                          )
                                        : null;
                                if (nu === null) return;
                                nu = String(nu).trim();
                                if (nu) a.setAttribute('data-pilot-href', nu);
                                else a.removeAttribute('data-pilot-href');
                                fireChanged();
                            });
                            var rm = document.createElement('button');
                            rm.type = 'button';
                            rm.className = 'ai-hd-pilot-del-link ai-hd-admin-editable';
                            rm.setAttribute('aria-label', '링크 삭제');
                            rm.textContent = '\u00d7';
                            rm.addEventListener('click', function (ev) {
                                ev.preventDefault();
                                li.remove();
                                fireChanged();
                            });
                            li.appendChild(ed);
                            li.appendChild(rm);
                        }
                        ul.appendChild(li);
                        if (!silent) fireChanged();
                    }

                    function wireCard(col, cardOpts) {
                        applyCardVariant(col, cardOpts || {});
                        var ul = col.querySelector('.ai-hd-pilot-ul');
                        var delM = col.querySelector('.ai-hd-pilot-del-module');
                        var renM = col.querySelector('.ai-hd-pilot-rename-module');
                        var addL = col.querySelector('.ai-hd-pilot-add-link');
                        if (renM) {
                            renM.addEventListener('click', function (ev) {
                                ev.preventDefault();
                                var te = col.querySelector('.ai-hd-pilot-title');
                                if (!te) return;
                                var nt =
                                    typeof window.prompt === 'function'
                                        ? window.prompt('모듈명', te.textContent.trim())
                                        : null;
                                if (nt === null) return;
                                te.textContent = String(nt).trim() || te.textContent;
                                fireChanged();
                            });
                        }
                        if (delM) {
                            delM.addEventListener('click', function () {
                                col.remove();
                                fireChanged();
                            });
                        }
                        if (addL && ul) {
                            addL.addEventListener('click', function () {
                                var t =
                                    typeof window.prompt === 'function'
                                        ? window.prompt('링크 이름', '새 링크')
                                        : null;
                                if (t === null) return;
                                var label = String(t).trim() || '새 링크';
                                var u =
                                    typeof window.prompt === 'function'
                                        ? window.prompt(
                                              '링크 주소 (http(s)://… 또는 /path, 비우면 클릭 시 안내 팝업)',
                                              ''
                                          )
                                        : null;
                                if (u === null) return;
                                addLink(ul, label, String(u).trim());
                            });
                        }
                    }

                    function addModule(title, links, cardOpts, silent, moduleIdOpt) {
                        if (typeof silent === 'undefined') silent = false;
                        var frag = tpl.content.cloneNode(true);
                        var col = frag.firstElementChild;
                        if (!col) return;
                        modSeq += 1;
                        var mid =
                            moduleIdOpt != null && String(moduleIdOpt).trim()
                                ? String(moduleIdOpt).trim()
                                : genModuleId();
                        col.setAttribute('data-module-id', mid);
                        var tit =
                            title != null && String(title).trim()
                                ? String(title).trim()
                                : defaultPrefix + ' ' + modSeq;
                        var titleEl = col.querySelector('.ai-hd-pilot-title');
                        if (titleEl) titleEl.textContent = tit;
                        var ul = col.querySelector('.ai-hd-pilot-ul');
                        (links || []).forEach(function (x) {
                            if (typeof x === 'string') addLink(ul, x, '', silent, null);
                            else
                                addLink(
                                    ul,
                                    (x && x.label) || '링크',
                                    (x && x.href) != null ? String(x.href) : '',
                                    silent,
                                    x && x.linkId
                                );
                        });
                        wireCard(col, cardOpts || {});
                        root.appendChild(col);
                        if (!silent) fireChanged();
                    }

                    function clearAll() {
                        root.innerHTML = '';
                    }

                    function getData() {
                        var out = [];
                        root.querySelectorAll(':scope > .ai-hd-col').forEach(function (col) {
                            var card = col.querySelector('.ai-hd-pilot-card');
                            if (!card) return;
                            var mid = (col.getAttribute('data-module-id') || '').trim();
                            var t = card.querySelector('.ai-hd-pilot-title');
                            var title = t ? t.textContent.trim() : '';
                            var links = [];
                            card.querySelectorAll('.ai-hd-pilot-ul li.ai-hd-pilot-li').forEach(function (li) {
                                var a = li.querySelector('a');
                                if (!a) return;
                                var lid = (li.getAttribute('data-link-id') || '').trim();
                                links.push({
                                    linkId: lid,
                                    label: a.textContent.trim(),
                                    href: (a.getAttribute('data-pilot-href') || '').trim()
                                });
                            });
                            var row = {
                                moduleId: mid,
                                title: title,
                                links: links,
                                featured: card.classList.contains('ai-hd-card--featured')
                            };
                            out.push(row);
                        });
                        return out;
                    }

                    function loadData(items, silent) {
                        if (typeof silent === 'undefined') silent = false;
                        clearAll();
                        if (!items || !items.length) return;
                        items.forEach(function (item) {
                            addModule(item.title, item.links || [], {
                                featured: !!(item && item.featured)
                            }, silent, item && item.moduleId);
                        });
                    }

                    if (addBtn) {
                        addBtn.addEventListener('click', function () {
                            var layer = document.getElementById('aiHelpDeskLayer');
                            if (
                                window.OPEN2U_AI_HELPDESK_ADMIN &&
                                layer &&
                                !layer.classList.contains('ai-hd-edit-mode-on')
                            ) {
                                return;
                            }
                            addModule('', [], {}, false, null);
                        });
                    }

                    return {
                        addModule: addModule,
                        clear: clearAll,
                        getData: getData,
                        load: loadData,
                        closeDetail: closeAgentDetailLayer
                    };
                }

                var noopApi = {
                    addModule: function () {},
                    clear: function () {},
                    getData: function () {
                        return [];
                    },
                    load: function () {},
                    closeDetail: closeAgentDetailLayer
                };

                var pilotCtrl = createMenuController({
                    rootId: 'aiPilotMenuCols',
                    templateId: 'aiPilotCardTpl',
                    addBtnId: 'aiPilotAddModule',
                    menuKindLabel: 'PILOT 메뉴',
                    fallbackDetailHeading: 'PILOT',
                    defaultModulePrefix: 'PILOT 모듈',
                    onChanged: function () {
                        queuePersist('PILOT');
                    },
                    onLinkOpen: function (payload) {
                        if (typeof window.OPEN2U_PILOT_MENU_onLinkOpen === 'function') {
                            window.OPEN2U_PILOT_MENU_onLinkOpen(payload);
                        }
                    }
                });

                var scmCtrl = createMenuController({
                    rootId: 'aiScmMenuCols',
                    templateId: 'aiScmCardTpl',
                    addBtnId: 'aiScmAddModule',
                    menuKindLabel: 'SCM 메뉴',
                    fallbackDetailHeading: 'SCM',
                    defaultModulePrefix: 'SCM 모듈',
                    trackFeatured: true,
                    onChanged: function () {
                        queuePersist('SCM');
                    },
                    onLinkOpen: function (payload) {
                        if (typeof window.OPEN2U_SCM_MENU_onLinkOpen === 'function') {
                            window.OPEN2U_SCM_MENU_onLinkOpen(payload);
                        }
                    }
                });

                window.OPEN2U_PILOT_MENU = pilotCtrl || noopApi;
                window.OPEN2U_SCM_MENU = scmCtrl || noopApi;

                function fallbackPilotItems() {
                    return [
                        {
                            title: 'PILOT 운영',
                            links: [
                                { label: '일정·현황', href: '' },
                                { label: '요청 등록', href: '' }
                            ]
                        }
                    ];
                }

                function fallbackScmItems() {
                    return [
                        {
                            title: '구매계획 AI',
                            featured: false,
                            links: [
                                { label: '수요 예측', href: '' },
                                { label: '예산 관리', href: '' },
                                { label: '구매 일정', href: '' }
                            ]
                        },
                        {
                            title: '소싱전략 AI',
                            featured: true,
                            links: [
                                { label: '업체 추천', href: '' },
                                { label: '업체 적합성 평가', href: '' }
                            ]
                        },
                        {
                            title: '입찰지원 AI',
                            featured: true,
                            links: [
                                { label: 'RFP/평가표 작성', href: '' },
                                { label: '제안서 평가', href: '' }
                            ]
                        },
                        {
                            title: '협상지원 AI',
                            featured: false,
                            links: [
                                { label: 'Target Price 분석', href: '' },
                                { label: '시장가 수집/분석', href: '' },
                                { label: '계약서 작성', href: '' }
                            ]
                        },
                        {
                            title: '정산 AI',
                            featured: true,
                            links: [
                                { label: '검사조서 처리', href: '' },
                                { label: '전표 처리', href: '' }
                            ]
                        },
                        {
                            title: 'Risk관리 AI',
                            featured: true,
                            links: [
                                { label: '계약 자정점검', href: '' },
                                { label: 'SW공급망 평가조회', href: '' }
                            ]
                        },
                        {
                            title: '업무지원 AI',
                            featured: true,
                            links: [
                                { label: '구매실적 Reporter', href: '' },
                                { label: '구매 문의 응대', href: '' }
                            ]
                        },
                        {
                            title: '동반성장 AI',
                            featured: false,
                            links: [
                                { label: '동반성장 PG 실적관리', href: '' },
                                { label: '증빙자료 검수', href: '' }
                            ]
                        }
                    ];
                }

                function loadMenusFromServer() {
                    var usePilotOverride =
                        Array.isArray(window.OPEN2U_PILOT_MENU_ITEMS) && window.OPEN2U_PILOT_MENU_ITEMS.length > 0;
                    var useScmOverride =
                        Array.isArray(window.OPEN2U_SCM_MENU_ITEMS) && window.OPEN2U_SCM_MENU_ITEMS.length > 0;
                    if (usePilotOverride && pilotCtrl) {
                        pilotCtrl.load(window.OPEN2U_PILOT_MENU_ITEMS, true);
                    }
                    if (useScmOverride && scmCtrl) {
                        scmCtrl.load(window.OPEN2U_SCM_MENU_ITEMS, true);
                    }
                    var jobs = [];
                    if (!usePilotOverride && pilotCtrl) {
                        jobs.push(
                            fetch(CTX + '/AiAgentMenuGet.do?section=PILOT')
                                .then(function (r) {
                                    if (!r.ok) throw r;
                                    return r.json();
                                })
                                .then(function (d) {
                                    pilotCtrl.load(d, true);
                                })
                        );
                    }
                    if (!useScmOverride && scmCtrl) {
                        jobs.push(
                            fetch(CTX + '/AiAgentMenuGet.do?section=SCM')
                                .then(function (r) {
                                    if (!r.ok) throw r;
                                    return r.json();
                                })
                                .then(function (d) {
                                    scmCtrl.load(d, true);
                                })
                        );
                    }
                    if (!jobs.length) return;
                    Promise.all(jobs).catch(function () {
                        if (!usePilotOverride && pilotCtrl) pilotCtrl.load(fallbackPilotItems(), true);
                        if (!useScmOverride && scmCtrl) scmCtrl.load(fallbackScmItems(), true);
                    });
                }

                loadMenusFromServer();
            })();
</script>
