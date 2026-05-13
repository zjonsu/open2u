$(function () {
    popInfoSlide();
    requestBtn();
    boxSlide();
    tblSlide();
    infoDetail();
    selectSlide01();
    tblFade();
    selectSlide02();
    excelItemChk();
    scrollCustom();
    managerChk();
    tab('.tab_btn');
    progressBar();
    counterUp($('.counter'));
});

// pop_info_area 접고 펼치기
function popInfoSlide () {
    var popInfoArea = $('.pop_header .pop_info_area');
    var togBtn = $('.pop_info_area .toggle_btn');

    togBtn.on('click', function () {
        popInfoArea.toggleClass('on');

        if(popInfoArea.hasClass('on')) {
            $(this).find('.txt').text('Close');
        } else {
            $(this).find('.txt').text('Open');
        }
    });
}

// 최종인수 요청하기 버튼
function requestBtn () {
    var btn = $('.btn.request');
    var fileLink = $('.file_link');

    btn.on('click', function() {
        $(this).addClass('active');
        fileLink.fadeIn(100);
    });
};

// layer_popup
function layerPopup (pop, coachMark) {
    var $_pop = $('[data-role-popup=' + pop + ']');
    var $_coachMark = coachMark ? $('[data-role-popup="' + coachMark + '"]') : null;

    $_pop.fadeIn();
    
    if ($_coachMark && $_coachMark.length) {
        $_coachMark.fadeIn();
    }
    // $('.layer_popup .dim').on('click', function () {
    //     $(this).closest('.layer_popup').fadeOut();
    // });
};

function layerClose (btn) {
    $(btn).closest('.layer_popup').fadeOut();
    $(btn).closest('.cm_layer_popup').fadeOut();
};


// 레이어 팝업 슬라이드 박스 접고 펼치기
function boxSlide () {
    var btn = $('.box_tit_area');

    $('.slide_box_wrap').each(function() {
        var boxCont = $(this).find('.box_cont_area');

        if($(this).hasClass('on')) {
            boxCont.show();
        } else {
            boxCont.hide();
        }
    });

    btn.on('click', function () {
        var slideBox = $(this).closest('.slide_box_wrap');
        var thisBoxCont = $(this).next('.box_cont_area');

        if(slideBox.hasClass('on')) {
            slideBox.removeClass('on');
            thisBoxCont.stop(true, true).slideUp(300);
        } else {
            slideBox.addClass('on');
            thisBoxCont.stop(true, true).slideDown(300);
        }
    });
};

//상세정보 접고 펼치기
function infoDetail () {
    var btn = $('.detail_info_btn:not(.no_event)');
    var infoDetail = $('.detail_info');

    btn.on('click', function () {
        if($(this).hasClass('active')) {
            $(this).removeClass('active');
            infoDetail.fadeOut(100);
        } else {
            $(this).addClass('active');
            infoDetail.fadeIn(100);
        }
    });
};

// 지급처정보 select box 접고 펼치기
function selectSlide01 () {
    $('.file_select_wrap').each(function () {
        var btn = $(this).find('.file_select_btn');
        var selectList = $(this).find('.select_list');
        var selectElement = selectList.find('li a');

        btn.on('click', function (e) {
            e.stopPropagation();

            $('.file_select_btn').not(this).removeClass('on');
            $('.select_list').not(selectList).slideUp(300);

            if ($(this).hasClass('on')) {
                $(this).removeClass('on');
                selectList.stop(true, true).slideUp(300);
            } else {
                $(this).addClass('on');
                selectList.stop(true, true).slideDown(300);
            }
        });

        selectElement.on('click', function (e) {
            e.stopPropagation();

            var selectedList = $(this).find('.element_list').html();
            btn.find('.element_list').html(selectedList);
            
            $(this).parents('li').addClass('active').siblings('li').removeClass('active');
            btn.removeClass('on');
            selectList.stop(true, true).slideUp(300);
        });

        selectList.on('click', function (e) {
            e.stopPropagation();

            btn.removeClass('on');
            selectList.stop(true, true).slideUp(300);
        });
    });

    $(document).on('click', function () {
        $('.file_select_btn').removeClass('on');
        $('.select_list').stop(true, true).slideUp(300);
    });
}

// 테이블 fadeInOut
function tblFade () {
    var btn = $('.tbl_fade_btn');

    btn.on('click', function () {
        var table =  $(this).closest('.sub_tit_area').next();

        var openText = $(this).data('text-open');
        var closeText = $(this).data('text-close');

        if($(this).hasClass('active')) {
            $(this).removeClass('active').text(closeText);
            table.hide();
        } else {
            $(this).addClass('active').text(openText);
            table.fadeIn(300);
        }
    });
};

// 테이블 접고 펼치기
function tblSlide () {
    var btn = $('.list_fade_btn');

    btn.on('click', function () {
        var thisTblWrap = $(this).closest('.tbl_fade_wrap');
        var thisfadeTbl = thisTblWrap.find('table tbody tr.hide_tbl_mark ~ tr');

        var openText = $(this).data('text-open');
        var closeText = $(this).data('text-close');

        if (thisTblWrap.hasClass('on')) {
            thisTblWrap.removeClass('on');
            thisfadeTbl.stop(true, true).hide();
            $(this).text(closeText);
        } else {
            thisTblWrap.addClass('on');
            thisfadeTbl.stop(true, true).fadeIn(300);
            $(this).text(openText);
        }
    });
}

// 추가증빙 select box 접고 펼치기
function selectSlide02 () {
    var selectInput = $('.file_form_control');
    var btn = $('.select_list_btn');
    var selectList = $('.file_select_list_wrap');
    var selectListOption = $('.file_select_list > li > a');

    btn.on('click', function () {
        var thisSelectList = $(this).next(selectList);

        selectList.not(thisSelectList).removeClass('on').slideUp(300)

        if (thisSelectList.hasClass('on')) {
            thisSelectList.removeClass('on').stop(true, true).slideUp(300);
        } else {
            thisSelectList.addClass('on').stop(true, true).slideDown(300);
        }
    });

    selectListOption.on('click', function () {
        var thisLi = $(this).closest('li');
        var input = thisLi.closest('.file_select_wrap').find('.file_form_control')

        if (!thisLi.hasClass('active')) {
            thisLi.addClass('active').siblings('li').removeClass('active');   
        }

        if(thisLi.hasClass('self_write')) {
            input.val('').attr('placeholder', '직접 입력').removeAttr('readonly').focus();
        } else {
            input.val($(this).text()).attr('readonly', 'readonly');
        }

        selectList.removeClass('on').stop(true, true).slideUp(300);
    });

    selectInput.on('click', function () {
        selectList.removeClass('on').stop(true, true).slideUp(300);
    });

    $(document).on('click', function (e) {
        if (!$(e.target).closest('.file_select_wrap').length) {
            selectList.removeClass('on').stop(true, true).slideUp(300);
        }
    });
};

// 엑셀다운로드 항목 선택
function excelItemChk () {
    var item = $('.item_check_list li');

    item.on('click', function () {
        if($(this).hasClass('active')) {
            $(this).removeClass('active');
        } else {
            $(this).addClass('active');
        }
    });
}

// mCsutomScrollbar
function scrollCustom () {
    var scrollBar = $('.scroll_y');

    scrollBar.mCustomScrollbar({
        theme: 'minimal-dark',
        axis: 'y',
        scrollInertia: 500,
        autoHideScrollbar: false,
        alwaysShowScrollbar: 0,
    });
}

// 담당자 선택
function managerChk () {
    var list = $('.manager_list li a');

    list.on('click', function () {
        var thisLi = $(this).closest('li');

        if(!thisLi.hasClass('on')) {
            thisLi.addClass('on').siblings('li').removeClass('on');
        }
    });
}

// tab
function tab (btn) {
    var $btn = $(btn);

    $btn.on('click', function () {
        var tab_id = $(this).attr('data-tab');
        $(this).closest('li').addClass('active').siblings().removeClass('active');
        $('#' + tab_id).stop(true, true).fadeIn().addClass('on').siblings().stop(true, true).hide(0).removeClass('on');
    });
}

//progress bar
function progressBar () {
    $('.progress_bar').each(function(){
        var dataWidth = $(this).data('width');
        var val = $(this).closest('.bar_bg').next('.val').find('strong');

        $(this).animate(
            { width: dataWidth + '%'},
            { 
                easing: 'easeInOutSine',
                duration: 700
            }
        )

        val.text(dataWidth);
    });
}

//counter 애니메이션
function counterUp ($elements) {
    $elements.each(function () {
        const $el = $(this);
        const targetValue = parseFloat($el.text().replace(/,/g, ''));
        const isDecimal = targetValue % 1 !== 0;

        $el.prop('number', 0).animateNumber(
            {
                number: targetValue,
                numberStep: function (now, tween) {
                    const formatted = isDecimal
                        ? now.toFixed(1)
                        : Math.floor(now).toLocaleString();
                    $(tween.elem).text(formatted);
                },
            },
            700
        );
    });

}
