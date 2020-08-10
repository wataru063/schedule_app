$(function () {
  // 画面遷移を検知
  $(document).on('turbolinks:load', function () {
    // lengthを呼び出すことで、#calendarが存在していた場合はtrueの処理がされ、無い場合はnillを返す
    if ($('#calendar').length) {
      function eventCalendar() {
        return $('#calendar').fullCalendar({
        });
      };
      function clearCalendar() {
        $('#calendar').html('');
      };

      $(document).on('turbolinks:load', function () {
        eventCalendar();
      });
      $(document).on('turbolinks:before-cache', clearCalendar);

      $('#calendar').fullCalendar({
        //events: '/events.json',
        events: {
          url: '/events.json',
          extraParams: function () { // a function that returns an object
            return {
              facility_id: $('#facility-calendar').val(),
            };
          }
        },
        titleFormat: 'YYYY年 M月',
        //曜日を日本語表示
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
