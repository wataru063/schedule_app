$(function() {
  var ajax = ''
  $('.admin-info').on('click', '.admin-user-search', function() {
    ajax = '1'
    console.log('test')
  });
  $('.admin-info').on('submit', '#admin-user-form', function(event) {
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

