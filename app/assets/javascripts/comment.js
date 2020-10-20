$(function () {
  $(document).on('turbolinks:load', function () {
    $('.construction_modal').on('keyup', '#comment-text', function () {
      if (!$(this).val().trim()) {
        $('#comment-save').attr('disabled', true);
      } else {
        $('#comment-save').attr('disabled', false);
      }
    });
    $('.construction_modal').on('click', '.show_more', function () {
      var show_content = $(this).parent(".content-wrapper").find(".content");
      var small_height = 25;
      var original_height = show_content.css({
        height: "auto"
      }).height();

      if (show_content.hasClass("open")) {
        show_content.height(original_height).animate({
          height: small_height
        }, 300);
        show_content.removeClass("open");
        $(this).html('<i class="fas fa-angle-down"></i> &nbsp; 続きを読む').removeClass("active-long");
      } else {
        show_content
          .height(small_height)
          .animate({
            height: original_height
          }, 300, function () {
            show_content.height("auto");
          });
        show_content.addClass("open");
        $(this).html('<i class="fas fa-angle-up"></i> &nbsp; 閉じる').addClass("active-long");
      }
    });
  });
});
