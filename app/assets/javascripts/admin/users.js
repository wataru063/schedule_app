$(function() {
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

