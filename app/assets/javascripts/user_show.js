$(function () {

  history.replaceState(null, document.getElementsByTagName('title')[0].innerHTML, null);
  window.addEventListener('popstate', function () {
    console.log("popstate")
    window.location.reload();
  });

  document.addEventListener("turbolinks:load", function () {
    var slideLine = $("#slide-line")
    var aTag = $(".related-info a")

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

    aTag.click(function () {
      if ($(this).hasClass("current")) { } else {
        $(".current").removeClass("current");
        $(this).addClass("current");
      }
    });

    aTag.hover(
      function () {
        slideLine.css({
          "width": $(this).width() + 20,
          "left": $(this).offset().left - 10,
          "top": $(this).offset().top + 30
        });
      },
      function () {
        if ($(".current")) {
          slideLine.css({
            "width": $(".current").width() + 20,
            "left": $(".current").offset().left - 10,
            "top": $(".current").offset().top + 30
          });
        } else {
          slideLine.width(0);
        }
      }
    );
  });
});
