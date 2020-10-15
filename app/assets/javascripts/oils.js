$(function () {
  $(document).on('turbolinks:load', function () {
    $('.order_modal, .construction_modal').on('change', '#facility-select', function () {
      $.get({
        url: '/oils/select',
        data: {
          facility_id: $('#facility-select').has('option:selected').val()
        },
      })
    });
  });
});
