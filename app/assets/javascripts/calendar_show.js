$(function () {
  $(document).on('turbolinks:load', function () {
    // calendar control
    var today = new Date();
    var id = $("#facility-calendar option:selected").val();
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
                facility_id: id
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
            if (date <= moment(today).format('YYYY-MM-DD')) {
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
      // window control
      var position_left = $("#calendar20").offset().left;
      var position_top = $("#calendar20").offset().top;
      $("#facility-calendar").css({
        "top": position_top,
        "left": position_left
      });
      $(window).resize(function () {
        var position_left = $("#calendar20").offset().left;
        var position_top = $("#calendar20").offset().top;
        $("#facility-calendar").css({
          "top": position_top,
          "left": position_left
        });
      });
      $("#facility-calendar").change(function () {
        document.calChangeForm.submit();
      });
    }
  });
});
