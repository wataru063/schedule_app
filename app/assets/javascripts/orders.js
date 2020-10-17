$(function () {
  $(document).on('turbolinks:load', function () {
    var enableSelectors = '#o-name, #o-companyName, #number'
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
      if (!!$('#o-name').val().trim() && !!$('#o-companyName').val().trim() && !!$('#number').val().trim()) {
        $('#o-btn').attr('disabled', false);
      } else {
        $('#o-btn').attr('disabled', true);
      }
    });
  });
});
