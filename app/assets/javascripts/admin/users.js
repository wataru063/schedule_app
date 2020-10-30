$(function() {
  $(document).on('turbolinks:load', function () {
    $('.admin-menu a').on('click', function () {
      $(".admin-menu a").removeClass('admin-active')
      $(this).addClass('admin-active')
    });

    var ajax = ''
    $('.admin-info').on('click', '.admin-search-btn', function() {
      ajax = '1'
    });
    $('.admin-info').on('submit', '#admin-operation-form', function(event) {
      if (!!ajax.length) {
        event.preventDefault();
        var $form = $(this);
        $.ajax({
          url: $form.attr('action'),
          dataType: "script",
          data: $form.serialize()
        });
      }
      ajax = ''
    });
  });
});

