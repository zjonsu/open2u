<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="main_cont">
    <div class="main_cont_left">
        <div class="main_board_inside">
            <div class="main_board_inner">
                <div class="main_board_top">
                    <div class="left">
                        <h2 class="title"><span>SCM</span>님의 To Do List</h2>
                    </div>
                    <div class="right">
                        <ul id="tabList01" class="department_list">
                            <li rel="tabCont01-01" class="on"><a href="javascript:;">개인</a></li>
                            <li rel="tabCont01-02"><a href="javascript:;">팀</a></li>
                        </ul>
                    </div>
                </div>
                <div id="tabCont01">
                    <div id="tabCont01-01" class="active">
                        <ul class="main_board_status">
                            <li><i class="icons i_main_status01"></i> <span>요청</span></li>
                            <li><i class="icons i_main_status02"></i> <span>반송</span></li>
                            <li><i class="icons i_main_status03"></i> <span>접수</span></li>
                            <li><i class="icons i_main_status04"></i> <span>진행</span></li>
                            <li><i class="icons i_main_status05"></i> <span>완료</span></li>
                        </ul>
                        <ul class="main_board_list">
                            <li>
                                <span class="label_title">구매요청</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li class="on"><a href="javascript:;">10</a></li>
                                    <li><a href="javascript:;">100</a></li>
                                    <li><a href="javascript:;">1000</a></li>
                                    <li><a href="javascript:;">10000</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">계약변경</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">검사조서</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">구매전표</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascr<br>
                                    ipt:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                    <div id="tabCont01-02">
                        <ul class="main_board_status">
                            <li><i class="icons i_main_status01"></i> <span>요청</span></li>
                            <li><i class="icons i_main_status02"></i> <span>반송</span></li>
                            <li><i class="icons i_main_status03"></i> <span>접수</span></li>
                            <li><i class="icons i_main_status04"></i> <span>진행</span></li>
                            <li><i class="icons i_main_status05"></i> <span>완료</span></li>
                        </ul>
                        <ul class="main_board_list">
                            <li>
                                <span class="label_title">구매요청</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li class="on"><a href="javascript:;">10</a></li>
                                    <li><a href="javascript:;">100</a></li>
                                    <li><a href="javascript:;">1000</a></li>
                                    <li><a href="javascript:;">10000</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">계약변경</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">100</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">검사조서</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                    <li><a href="javascript:;">-</a></li>
                                </ul>
                            </li>
                            <li>
                                <span class="label_title">구매전표</span>
                                <ul class="number_list">
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                    <li><a href="javascr<br>
                                    ipt:;">3</a></li>
                                    <li><a href="javascript:;">3</a></li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
        <div class="main_bot_area inside">
            <ul class="main_banner_list">
                <li>
                    <a href="javascript:;" class="ico_type01">
                        <span>
                            구매담당자<br>
                            조회
                        </span>
                        <i class="icons i_main_banner"></i>
                    </a>
                </li>
                <li>
                    <a href="javascript:;" class="ico_type02">
                        <span>
                            Open2U<br>
                            사용 매뉴얼
                        </span>
                        <i class="icons i_main_banner"></i>
                    </a>
                </li>
                <li>
                    <a href="javascript:;" class="ico_type03">
                        <span>
                            구매Process<br>
                            동영상
                        </span>
                        <i class="icons i_main_banner"></i>
                    </a>
                </li>
                <li>
                    <a href="javascript:;" class="ico_type04">
                        <span>
                            구매요청/검사조서<br>
                            작성 동영상
                        </span>
                        <i class="icons i_main_banner"></i>
                    </a>
                </li>
            </ul>
            <div class="main_link_area">
                <ul class="main_link_list">
                    <li>
                        <a href="javascript:;">
                            <span class="icon"><i class="icons i_main_link01"></i></span>
                            <span class="label">외자구매</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:;">
                            <span class="icon"><i class="icons i_main_link02"></i></span>
                            <span class="label">동반성장</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:;">
                            <span class="icon"><i class="icons i_main_link03"></i></span>
                            <span class="label">카탈로그</span>
                        </a>
                    </li>
                    <li>
                        <a href="javascript:;">
                            <span class="icon"><i class="icons i_main_link04"></i></span>
                            <span class="label">
                                자산취득
                                (Q&A)
                            </span>
                        </a>
                    </li>
                </ul>
                <div class="main_link_box_area">
                    <div class="main_helpdesk_area">
                        <a href="javascript:;" id="aiHelpDeskOpen">
                            <strong class="tit">AI - <br>Help Desk</strong>
                            <span class="link_arr"></span>
                        </a>
                    </div>
                    <div class="main_biz_area">
                        <a href="javascript:;">
                            <strong class="tit">구매</strong>
                            <span class="link_arr"></span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="main_cont_right">
        <div class="main_title_area">
            <div class="left">
                <h2>최근 접속메뉴</h2>
            </div>
            <div class="right"></div>
        </div>
        <ul class="main_tag_list">
            <li><a href="javascript:;">#보증관리</a></li>
            <li><a href="javascript:;">#계약대장</a></li>
            <li><a href="javascript:;">#ITEM 현황</a></li>
            <li><a href="javascript:;">#공급사현황</a></li>
            <li><a href="javascript:;">#구매전표</a></li>
            <li><a href="javascript:;">#검사조서</a></li>
            <li><a href="javascript:;">#검사조서</a></li>
            <li><a href="javascript:;">#검사조서</a></li>
            <li><a href="javascript:;">#검사조서</a></li>
            <li><a href="javascript:;">#검사조서</a></li>
        </ul>

        <div class="main_title_area">
            <div class="left">
                <h2><a href="javascript:;">공지사항</a></h2>
            </div>
            <div class="right">
                <ul id="tabList02" class="main_notice_tab">
                    <li rel="tabCont02-01" class="on"><a href="javascript:;">신규</a></li>
                    <li rel="tabCont02-02"><a href="javascript:;">주요</a></li>
                </ul>
            </div>
        </div>

        <div id="tabCont02" class="main_notice_area">
            <div id="tabCont02-01" class="active">
                <ul class="main_notice_list">
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">
                            <em class="notice_new"></em>
                            2023 KISS 국제안전보건전시회에 초청합니다. 2023 KISS 국제안전보건전시회에 초청합니다.
                        </a>
                    </li>
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">안전보건 동영상 유튜브 채널 오픈 및 활용 안내</a>
                    </li>
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">적격수급업체평가 프로세스 안내</a>
                    </li>
                </ul>
            </div>
            <div id="tabCont02-02">
                <ul class="main_notice_list">
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">2023 KISS 국제안전보건전시회에 초청합니다.</a>
                    </li>
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">안전보건 동영상 유튜브 채널 오픈 및 활용 안내</a>
                    </li>
                    <li>
                        <div class="date_box">
                            <span class="days">07</span>
                            <span class="year_month">23.07</span>
                        </div>
                        <a href="javascript:;" class="title">적격수급업체평가 프로세스 안내</a>
                    </li>
                </ul>
            </div>
        </div>

        <div class="main_title_area">
            <div class="left">
                <h2>
                    FAQ <br>
                    <span>(자주묻는 질문)</span>
                </h2>
            </div>
            <div class="right">
                <a href="javascript:;" class="notice_link"><i class="icons i_notice_link"></i></a>
            </div>
        </div>

        <ul class="main_faq_list">
            <li>
                <span class="question"><em>Q</em> 제안분야</span>
                <a href="javascript:;" class="answer">모바일 관련 제안만 할 수 있나요? 모바일 관련 제안만 할 수 있나나 있나요?</a>
            </li>
            <li>
                <span class="question"><em>Q</em> 심사관련</span>
                <a href="javascript:;" class="answer">인터뷰나 발표 없이 제안 등록 내용 및 첨부 서류로만 심사하나요?</a>
            </li>
        </ul>
    </div>
</div>

<%-- AI Help Desk: 권한·전역(조각 JSTL·스크립트에서 사용). 추후 세션·역할 연동 시 이 블록만 조정 --%>
     <% boolean admin = true;
        request.setAttribute("aiHelpdeskAdmin", admin);
     %>
     <script>window.OPEN2U_CONTEXT_PATH = '${pageContext.request.contextPath}';</script>
     <script>window.OPEN2U_AI_HELPDESK_ADMIN = <%= admin %>;</script>


<%@ include file="/WEB-INF/jsp/home/ai-helpdesk-modal.jspf" %>
<script>
    tabMenu('#tabList01', '#tabCont01');
    tabMenu('#tabList02', '#tabCont02');
</script>
