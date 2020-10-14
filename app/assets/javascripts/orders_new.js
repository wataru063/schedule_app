$(function () {
  $(document).on('turbolinks:load', function () {
    $('.order_modal').on('change', '#facility-select', function () {
      $.get({
        url: '/orders/oil',
        data: {
          facility_id: $('#facility-select').has('option:selected').val()
        },
      })
    });
    var enableSelectors = '#o-new-name, #o-new-companyName, #number'
    $('.order_modal').on('keyup', enableSelectors, function () {
      var idName = '#' + $(this).attr('id');
      var label = $(idName + '-label').text().replace("※入力してください", "");
      if (!$(this).val().trim()) {
        $(this).css('border-color', 'red')
        $(idName + '-label').css('color', 'red')
        $(idName + '-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※入力してください<div>")
      } else {
        var changeLabel = $(idName + '-label').text().replace("※入力してください", "");
        $(this).css('border-color', '')
        $(idName + '-label').css('color', '')
        $(idName + '-label').html(changeLabel)
      }
      if (!!$('#o-new-name').val().trim() && !!$('#o-new-companyName').val().trim() && !!$('#number').val().trim()) {
        $('#o-new-btn').attr('disabled', false);
      } else {
        $('#o-new-btn').attr('disabled', true);
      }
    });
  });
});
