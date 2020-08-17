$(function () {
  $(document).on('turbolinks:load', function () {
    if ($('#calendar20').length) {
      function eventCalendar() {
        return $('#calendar20').fullCalendar({
        });
      };
      function clearCalendar() {
        $('#calendar20').html('');
      };
      $(document).on('turbolinks:load', function () {
        eventCalendar();
      });
      $(document).on('turbolinks:before-cache', clearCalendar);
      $('#calendar20').fullCalendar({
        events: {
            url: '/events_show.json',
            data: function () {
              return {
                facility_id: $("#facility-calendar option:selected").val()
              };
            },
          },
        titleFormat: 'YYYY年 M月',
        aspectRatio: 1.48,
        dayNamesShort: ['日', '月', '火', '水', '木', '金', '土'],
        //ボタンのレイアウト
        header: {
          left: '',
          center: 'prev, title, next',
          right: 'today '
        },
        //終了時刻がないイベントの表示間隔
        defaultTimedEventDuration: '03:00:00',
        buttonText: {
          prevYear: '前年',
          nextYear: '翌年',
          today: '今日',
          month: '月',
          week: '週',
          day: '日'
        },
        //イベントの時間表示を２４時間に
        timeFormat: "HH:mm",
        displayEventTime: false,
        eventRender: function (event, element) {
          element.css("font-size", "1.05em");
          element.css("padding", "3px");
          //element.css("border", "none");
        }
      });
    }
  });
});