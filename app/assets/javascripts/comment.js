$(function () {
  $(document).on('turbolinks:load', function () {
    $('.construction_modal').on('keyup', '#comment-text', function () {
      if (!$(this).val().trim()) {
        $('#comment-save').attr('disabled', true);
      } else {
        $('#comment-save').attr('disabled', false);
      }
    });
  });
});
