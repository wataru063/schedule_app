$(function () {
  $(document).on('turbolinks:load', function () {
    $('.construction-edit-content, .admin-info, .construction_modal').on('keyup', '#c-name', function () {
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
      if (!!$('#c-name').val().trim()) {
        $('#c-btn').attr('disabled', false);
      } else {
        $('#c-btn').attr('disabled', true);
      }
    });
  });
});
