$(function () {
  $(document).on('turbolinks:load', function () {
    $('.admin-menu a').on('click', function () {
      $(".admin-menu a").removeClass('admin-active')
      $(this).addClass('admin-active')
    });
  });
});
