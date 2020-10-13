$(function () {
  $(document).on('turbolinks:load', function () {
    var today = new Date();
    if ($("#calendar0").length) {
      function eventCalendar() {
        return $("#calendar0").fullCalendar({
        });
      };
      function clearCalendar() {
        $("#calendar0").html('');
      };
      $(document).on('turbolinks:load', function () {
        eventCalendar();
      });
      $(document).on('turbolinks:before-cache', clearCalendar);
      $('#calendar0').fullCalendar({
        titleFormat: 'YYYY年 M月',
        dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
        defaultDate: today,
        defaultView: 'basicWeek',
        header: {
          left: '',
          center: 'prev, title, next',
          right: 'today '
        },
        buttonText: {
          prevYear: '前年',
          nextYear: '翌年',
          today: '今日',
          month: '月',
          week: '週',
          day: '日'
        },
      });
    };

    $('.tabs').each(function () {
      if ($(this).length) {
        var id = $(this).data('calendar')
        function eventCalendar() {
            return $(this).fullCalendar({
            });
          };
          function clearCalendar() {
            $(this).html('');
          };
          $(document).on('turbolinks:load', function () {
            eventCalendar();
          });
          $(document).on('turbolinks:before-cache', clearCalendar);
        $(this).fullCalendar({
          events: {
            url: '/events_index.json',
            data: function () {
              return {
                facility_id: id
              };
            },
          },
          titleFormat: 'YYYY年 M月',
          dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
          header: {
            left: '',
            center: '',
            right: ''
          },
          defaultTimedEventDuration: '03:00:00',
          buttonText: {
            prevYear: '前年',
            nextYear: '翌年',
            today: '今日',
            month: '月',
            week: '週',
            day: '日'
          },
          timeFormat: "HH:mm",
          displayEventTime: false,
          defaultDate: today,
          defaultView: 'basicWeek',
          height: 200,
          eventRender: function (event, element) {
            element.css("font-size", "1.05em");
            element.css("padding", "3px");
            element.css("cursor", "pointer");
          },
          eventClick: function (calEvent, jsEvent, view) {
            var dt = calEvent.id;
            if (calEvent.flag == 0) {
              var name = 'constructions';
            } else if (calEvent.flag == 1) {
              var name = 'orders';
            }
            $.ajax({
              url: `/${name}/${dt}`,
              dataType: "script"
            });
          },
          dayClick: function (date, jsEvent, view) {
            var category_id = $('#cal_user_category').val();
            var date = date.format();
            if (category_id == 6) {
              var name = 'orders';
              if ( date <= moment(today).format('YYYY-MM-DD')) {
                alert('オーダーは翌日以降から登録可能です')
                return
              }
            } else if (category_id < 6) {
              var name = 'constructions';
              if (date <= moment(today).add(2, 'months').format('YYYY-MM-DD')) {
                alert('工事は2ヶ月後以降から登録可能です \n緊急の場合はadmin権限を持つユーザーに登録を依頼してください')
                return
              }
            }
            $.ajax({
              url: `/${name}/new`,
              data: { date: date, facility_id: id },
              dataType: "script",
            });
          },
        });
      };
    });

    if ($('.tabs').length) {
      function eventCalendar() {
        return $('.tabs').fullCalendar({
        });
      };
      function clearCalendar() {
        $('.tabs').html('');
      };
      $(document).on('turbolinks:load', function () {
        eventCalendar();
      });
      $(document).on('turbolinks:before-cache', clearCalendar);
    }

    $('#calendar0 .fc-prev-button').click(function () {
      $('.tabs').each(function () {
        $(this).fullCalendar('prev');
      });
    });
    $('#calendar0 .fc-next-button').click(function () {
      $('.tabs').each(function () {
        $(this).fullCalendar('next');
      });
    });
    $('#calendar0 .fc-today-button').click(function () {
      $('.tabs').each(function () {
        $(this).fullCalendar('today');
      });
    });
  });
});
