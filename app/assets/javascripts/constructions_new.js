$(function () {
  $(document).on('turbolinks:load', function () {
    $('#facility-select').change(function () {
      $.get({
        url: '/constructions/oil',
        data: {
          facility_id: $('#facility-select').has('option:selected').val()
        },
      })
    });
    $('.construction_modal').on('keyup', '#c-new-name', function () {
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
      if (!!$('#c-new-name').val().trim()) {
        $('#c-new-btn').attr('disabled', false);
      } else {
        $('#c-new-btn').attr('disabled', true);
      }
    });
  });
});
