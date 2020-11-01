$(function () {
  history.replaceState(null, document.getElementsByTagName('title')[0].innerHTML, null);
  window.addEventListener('popstate', function () {
    window.location.reload();
  });
  document.addEventListener("turbolinks:load", function () {
    var parentsTag = '.related-info-wrapper, .admin-info'
    var aTag = ".related-info a"
    $('.admin-info').on('shown.bs.modal', '#userShowModal', function () {
      var slideLine = $("#slide-line")
      if ($(".current").length) {
        slideLine.css({
          "width": $(".current").width() + 20,
          "left": $(".current").offset().left - 10,
          "top": $(".current").offset().top + 30
        });
      }
      $(window).resize(function () {
        if ($(".current").length) {
          slideLine.css({
            "width": $(".current").width() + 20,
            "left": $(".current").offset().left - 10,
            "top": $(".current").offset().top + 30
          });
        }
      });
    });
    if ($(".current").length) {
      $("#slide-line").css({
        "width": $(".current").width() + 20,
        "left": $(".current").offset().left - 10,
        "top": $(".current").offset().top + 30
      });
    }
    $(window).resize(function () {
      if ($(".current").length) {
        $("#slide-line").css({
          "width": $(".current").width() + 20,
          "left": $(".current").offset().left - 10,
          "top": $(".current").offset().top + 30
        });
      }
    });
    $(parentsTag).on('click', aTag, function () {
      if ($(this).hasClass("current")) { } else {
        $(".current").removeClass("current");
        $(this).addClass("current");
      }
    });
    $(parentsTag).on({
      "mouseenter": function () {
        $("#slide-line").css({
          "width": $(this).width() + 20,
          "left": $(this).offset().left - 10,
          "top": $(this).offset().top + 30
        });
      },
      "mouseleave": function () {
        if ($(".current")) {
          $("#slide-line").css({
            "width": $(".current").width() + 20,
            "left": $(".current").offset().left - 10,
            "top": $(".current").offset().top + 30
          });
        } else {
          $("#slide-line").width(0);
        }
      }
    }, aTag);

    var enableSelectors = '#u-name, #u-email, #u-pass, #u-pass-c'
    $('.user_form, .admin-info').on('keyup', enableSelectors, function () {
      var idName = '#' + $(this).attr('id');
      var label = $(idName + '-label').text().replace("※入力してください", "").replace("※255文字以内で入力してください", "").replace("※50文字以内で入力してください", "").replace("※6文字以上で入力してください", "").replace("※パスワードと異なります", "");
      if (!$(this).val().trim()) {
        $(this).css('border-color', 'red')
        $(idName + '-label').css('color', 'red')
        $(idName + '-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※入力してください<div>")
      } else if (idName == '#u-name' && $('#u-name').val().length > 50) {
        $('#u-name').css('border-color', 'red')
        $('#u-name-label').css('color', 'red')
        $('#u-name-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※50文字以内で入力してください<div>")
      } else if (idName == '#u-email' && $('#u-email').val().length > 255) {
        $('#u-email').css('border-color', 'red')
        $('#u-email-label').css('color', 'red')
        $('#u-email-label').html("パスワード<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※255文字以内で入力してください<div>")
      } else if (idName == '#u-pass' && $('#u-pass').val().length < 6) {
        $('#u-pass').css('border-color', 'red')
        $('#u-pass-label').css('color', 'red')
        $('#u-pass-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※6文字以上で入力してください<div>")
        if ($('#u-pass-c').val() !== $('#u-pass').val()) {
          $('#u-pass-c').css('border-color', 'red')
          $('#u-pass-c-label').css('color', 'red')
          $('#u-pass-c-label').html("パスワード(確認用)<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※パスワードと異なります<div>")
        }
      } else if (idName == '#u-pass-c' && $('#u-pass-c').val() !== $('#u-pass').val()) {
        $('#u-pass-c').css('border-color', 'red')
        $('#u-pass-c-label').css('color', 'red')
        $('#u-pass-c-label').html("パスワード(確認用)<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※パスワードと異なります<div>")
      } else {
        var changeLabel = $(idName + '-label').text().replace("※入力してください", "").replace("※255文字以内で入力してください", "").replace("※50文字以内で入力してください", "").replace("※6文字以上で入力してください", "").replace("※パスワードと異なります", "");
        $(this).css('border-color', '')
        $(idName + '-label').css('color', '')
        $(idName + '-label').html(changeLabel)
      }
      if (!($('#u-pass').length) && !!$('#u-name').val().trim() && !!$('#u-email').val().trim() && $('#u-email').val().length <= 255 && $('#u-name').val().length <= 50) {
        $('#u-btn').attr('disabled', false);
      } else if ($('#u-pass-c').length && $('#u-pass').val().length >= 6 && $('#u-pass-c').val() === $('#u-pass').val() && $('#u-pass-c').val().length >= 6 && !!$('#u-name').val().trim() && !!$('#u-email').val().trim() && $('#u-email').val().length <= 255 && $('#u-name').val().length <= 50) {
        $('#u-btn').attr('disabled', false);
      } else if ($('#u-pass').length && !($('#u-pass-c').length) && $('#u-pass').val().length >= 6 && !!$('#u-email').val().trim() && $('#u-email').val().length <= 255) {
        $('#u-btn').attr('disabled', false);
      } else {
        $('#u-btn').attr('disabled', true);
      }
    });
  });
});
