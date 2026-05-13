$(function () {
    datePicker();
    searchToggle();
    $('.ui_tooltip').tooltip();
    selecDrop();
    readOnlyBgc();
});

function datePicker() { // 2025-06-12 수정
    // datepicker
    $(".datepicker").datepicker({
        showOn: "both", // 버튼과 텍스트 필드 모두 캘린더를 보여준다.
        buttonImage: "../../resource/images/new_common/ico_calendar.svg", // 버튼 이미지.
        dateFormat: "yy.mm.dd", // 텍스트 필드에 입력되는 날짜 형식.
        changeMonth: true,
        changeYear: true,
        nextText: "다음 달", // next 아이콘의 툴팁.
        prevText: "이전 달", // prev 아이콘의 툴팁.
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNames: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesShort: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],
        beforeShow: function (input) {
            $('#ui-datepicker-div').removeClass('custom-ty02-datepicker');

            if ($(input).closest('.datepicker_area').hasClass('ty02')) {
                $('#ui-datepicker-div').addClass('custom-ty02-datepicker');
            }
        }
    });
}

function searchToggle() {
    $(".search_toggle").on("click", function () {
        $(this).toggleClass("on");
        $(".sch_area").toggleClass("on");
        if ($(this).children('span').text() == "접기") {
            $(this).children('span').text("펼치기");
        } else {
            $(this).children('span').text("접기");
        }
    });
}

//top GNB
$(function () {
    $("ul.dropdown li").hover(
        function () {
            $(this).addClass("hover");
            $("ul:first", this).css("visibility", "visible");
        },
        function () {
            $(this).removeClass("hover");
            $("ul:first", this).css("visibility", "hidden");
        }
    );

    $("ul.dropdown li ul li:has(ul)").find("a:first");
});

//tab menu
$(function () {
    $(".tab_content").hide();
    $(".tab_content:first").show();

    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("tabs_on");
        $(this).addClass("tabs_on");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
    });
    $("ul.tabs01 li").click(function () {
        $("ul.tabs01 li").removeClass("tabs01_on");
        $(this).addClass("tabs01_on");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
    });
});

//전체메뉴
$(function () {
    $(".sitemapBtn").click(function () {
        if (!$(this).hasClass("open")) {
            $(".siteMapArea").slideDown(300);
            $(this).addClass("open");
        } else {
            $(".siteMapArea").slideUp(300);
            $(this).removeClass("open");
        }
    });
});
$(function () {
    $(".siteMapClosebtn").click(function () {
        if ($(".sitemapBtn").hasClass("open")) {
            $(".siteMapArea").slideUp(300);
            $(".sitemapBtn").removeClass("open");
        }
    });
});

//textarea 확장/축소
$(function () {
    $(".sizetoggle").click(function () {
        $(this).toggleClass('on');
        $('.sizetoggle_box').toggleClass('on');
    });
});

// 페이지 top버튼
$(function(){
    $(window).on("scroll touchmove mousewheel DOMMouseScroll", function(e) {
        if($(window).scrollTop() >= 20) $(".btn_top").addClass('on');
            else $(".btn_top").removeClass('on');
        });
        $(".btn_top").click(function(){
        $("html,body").animate({ scrollTop: 0 }, "2000");
    });
});

// 탭 메뉴
function tabMenu(e, cont) {

    var tabMenu = null,
        tabMenuList = null,
        tabCont = null,
        tabContShow = null;

    function tabMenuFunc(e) {
        tabMenu = $(e);
        tabMenuList = tabMenu.find('li a');
        tabCont = $(cont).children();
        tabContShow = $(cont).children('.active');

        tabCont.hide();
        tabContShow.show();

        tabMenuList.on('click', function () {
            tabMenuList.parent('li').removeClass('on');
            $(this).parent('li').addClass('on');
            tabCont.hide();
            var activeTabs = $(this).parent('li').attr('rel');
            $('#' + activeTabs).stop().fadeIn();
        });
    }

    tabMenuFunc(e);
}

// 팝업오픈
function popupFunc(e) {
    var layerPop = $("#" + e);
    popClose = $(".lay_pop_bg, .lay_pop_close");

    layerPop.addClass("active");

    popClose.on("click", function () {
        $(this).parents(layerPop).removeClass("active"); /* 2022-09-01 수정 */
    });
}

function selecDrop(){
    var button = $('.selec_drop_area button'),
        menu = $(".selec_drop_box ul  li");

    button.on('click',function(){
        $(this).next("ul").stop().slideToggle('50');
		$(this).toggleClass("on");
        $('.selec_drop_box').toggleClass('on');
		return false;
    });

}

function readOnlyBgc(){
	$("input.datepicker[readonly]").each(function(){
		$(this).parent().parent().addClass("read_only");
	});
    $("input.datepicker").attr('readonly', true).each(function(){
		$(this).parent().parent().addClass("read_only");
	});
}

