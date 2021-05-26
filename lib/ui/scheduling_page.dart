import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:save_ai/ui/update_page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:toast/toast.dart';
import 'package:save_ai/utils/scheduling.dart';

List meetings = <Meeting>[];

class SchedulePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SchedulePageState();
  }
}

class SchedulePageState extends State<SchedulePage>
    with AutomaticKeepAliveClientMixin {

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  void longPressed(CalendarLongPressDetails calendarLongPressDetails) {
    DateTime _stime;
    DateTime _etime;

    _stime = calendarLongPressDetails.date;
    _etime = _stime.add(const Duration(hours: 1));

    print(_stime);

    setState(() {
      meetings.removeWhere((element) {
        Meeting meeting = element;
        if (meeting.from == _stime) {
          return true;
        } else {
          return false;
        }
      });
    });

    // Toast.show("Please select a start time", context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    // DatePicker.showTime12hPicker(context,
    //     showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
    //   _stime = time;
    //   Toast.show("Please select an end time", context,
    //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    //   DatePicker.showTime12hPicker(context,
    //       showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
    //     _etime = time;
    //     setState(() {
    //       meetings.add(
    //           Meeting('Available', _stime, _etime, const Color(0xFF0F8644), false));
    //     });
    //   }, currentTime: calendarLongPressDetails.date);
    // }, currentTime: calendarLongPressDetails.date);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  void onTapped(CalendarTapDetails calendarTapDetails) {
    DateTime _stime;
    DateTime _etime;

    _stime = calendarTapDetails.date;
    _etime = _stime.add(const Duration(hours: 1));

    print(_stime);
    setState(() {
      meetings.add(
          Meeting('Available', _stime, _etime, Colors.lightGreen, false));
    });

    // Toast.show("Please select a start time", context,
    //     duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    // DatePicker.showTime12hPicker(context,
    //     showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
    //   _stime = time;
    //   Toast.show("Please select an end time", context,
    //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    //   DatePicker.showTime12hPicker(context,
    //       showTitleActions: true, onChanged: (time) {}, onConfirm: (time) {
    //     _etime = time;
    //     setState(() {
    //       meetings.add(
    //           Meeting('Available', _stime, _etime, const Color(0xFF0F8644), false));
    //     });
    //   }, currentTime: calendarLongPressDetails.date);
    // }, currentTime: calendarLongPressDetails.date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Availability",
          style: TextStyle(color: Color(0xFFff8552)),
        ),
      ),
      body: SfCalendar(
        view: CalendarView.week,
        // allowedViews: <CalendarView>[
        //   CalendarView.day,
        //   CalendarView.week,
        //   CalendarView.workWeek,
        //   CalendarView.month,
        //   CalendarView.timelineDay,
        //   CalendarView.timelineWeek,
        //   CalendarView.timelineWorkWeek,
        //   CalendarView.timelineMonth,
        //   CalendarView.schedule
        // ],
        dataSource: MeetingDataSource(_getDataSource()),
        onLongPress: longPressed,
        onTap: onTapped,
        monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
            showAgenda: true),
        showNavigationArrow: true,
        // showDatePickerButton: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFff8552),
        child: Icon(
          Icons.upload_rounded,
          color: Colors.white,
        ),
        onPressed: () async {
          List<List<int>> availability = [];
          meetings.forEach((element) {
            Meeting meeting = element;
            int from =
                ((meeting.from.weekday - 1) * 24 + meeting.from.hour) * 60;
            int end = from + 60;
            availability.add([from, end]);
          });
          await updateUserCal(availability);
          showInSnackBar("Updated the availability.");
        },
      ),
    );
  }
}

List<Meeting> _getDataSource() {
  // final DateTime today = DateTime.now();
  // final DateTime startTime =
  //     DateTime(today.year, today.month, today.day, 9, 0, 0);
  // final DateTime endTime = startTime.add(const Duration(hours: 3));
  // meetings.add(
  //     Meeting('Available', startTime, endTime, const Color(0xFF0F8644), false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
