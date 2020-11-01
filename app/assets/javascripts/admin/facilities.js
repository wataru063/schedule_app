$(function() {
  $(document).on('turbolinks:load', function () {
    $('.admin-info').on('click', "#oil-add-btn", function () {
      var action = $(this).data('action');
      var count = $(this).data('count');
      var oils = document.getElementById('facility-form-wrapper').getElementsByClassName('add-oils-wrapper');
      var nextSelectBoxNumber = oils.length + 1;
      if (count >= nextSelectBoxNumber) {
      $('#facility-form-wrapper').append(`<div class='add-oils-wrapper' id=add-oils-${nextSelectBoxNumber}><div class=facility-form id=facility-form-${nextSelectBoxNumber}'><select class='form-control oil-select' id='oil-select-${nextSelectBoxNumber}' name='facility[oil_id][${nextSelectBoxNumber}]'></select></div><input type='button' value='ー' class='adjust-btn btn o-select oil-remove-btn'></div>`)
        if (action == 'new') {
          $.ajax({
            url: '/admin/facilities/new',
            dataType: "script",
            data: { 'select_count': nextSelectBoxNumber }
          });
        } else {
          var id = $(this).data('id');
          $.ajax({
            url: `/admin/facilities/${id}/${action}`,
            dataType: "script",
            data: { 'select_count': nextSelectBoxNumber }
          });
        }
      }
    })
    $('.admin-info').on('click', ".oil-remove-btn", function () {
      var oils = document.getElementById('facility-form-wrapper').getElementsByClassName('add-oils-wrapper');
      var lastSelectBoxNumber = oils.length
      var $lastOil = $(`#add-oils-${lastSelectBoxNumber}`)
      $lastOil.remove();
    })
    function existsSameValue(a){
      var s = new Set(a);
      return s.size != a.length;
    }
    $('.admin-info').on('keyup', "#f-name", function () {
      var idName = '#' + $(this).attr('id');
      var label = $(idName + '-label').text().replace("※入力してください", "");
      var oils = document.getElementById('facility-form-wrapper').getElementsByClassName('oil-select');
      var check = [];
      for (let i = 0; i < oils.length; i++) { check.push(oils[i].value); }
      if (idName == '#f-name' && !$(this).val().trim()) {
        $(this).css('border-color', 'red')
        $(idName + '-label').css('color', 'red')
        $(idName + '-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※入力してください<div>")
      } else {
        var changeLabel = $(idName + '-label').text().replace("※入力してください", "");
        $(this).css('border-color', '')
        $(idName + '-label').css('color', '')
        $(idName + '-label').html(changeLabel)
      }
      if (!!$('#f-name').val().trim() && !existsSameValue(check)) {
        $('#f-btn').attr('disabled', false);
      } else {
        $('#f-btn').attr('disabled', true);
      }
    })
    $('.admin-info').on('change', ".oil-select", function () {
      var oils = document.getElementById('facility-form-wrapper').getElementsByClassName('oil-select');
      var check = [];
      for (let i = 0; i < oils.length; i++) { check.push(oils[i].value); }
      var idName = '#' + $(this).attr('id');
      var label = $('#o-select-label').text().replace("※重複できません", "");
      if (existsSameValue(check)) {
        $('.oil-select').css('border-color', 'red')
        $('#o-select-label').css('color', 'red')
        $('#o-select-label').html(label + "<div style='float:right;margin-left:10px;font-size:13px;  vertical-align: middle;'>※重複できません<div>")
      } else {
        var changeLabel = $('#o-select-label').text().replace("※重複できません", "");
        $('.oil-select').css('border-color', '')
        $('#o-select-label').css('color', '')
        $('#o-select-label').html(changeLabel)
      }
      if (!!$('#f-name').val().trim() && !existsSameValue(check)) {
        $('#f-btn').attr('disabled', false);
      } else {
        $('#f-btn').attr('disabled', true);
      }
    });
  });
});
