import 'dart:ui';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:save_ai/data/users.dart';
import 'package:save_ai/ui/scheduling_page.dart';
import 'package:save_ai/utils/router.dart';
import 'package:save_ai/utils/scheduling.dart';
import 'package:save_ai/widget/chat_item.dart';
import 'package:save_ai/data/chat_data.dart';
import 'package:save_ai/widget/post_item.dart';
import 'scheduling_page.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List schedule = [];
  List meetings = [];
  DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  List<Calendar> _calendars;
  Event _event;
  bool isSchEmpty = true, isCalEmpty = true, isFriendsEmpty = true;

  RefreshController _refreshController_sch =
      RefreshController(initialRefresh: true);

  RefreshController _refreshController_cal =
      RefreshController(initialRefresh: true);

  RefreshController _refreshController_friends =
      RefreshController(initialRefresh: true);

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      setState(() {
        _calendars = calendarsResult?.data;
      });

      bool calExist = false;
      _calendars.forEach((Calendar cal) {
        print(cal.name);
        if (cal.name == "SAVE-AI") {
          calExist = true;
        }
      });

      if (calExist == false) {
        var result = await _deviceCalendarPlugin.createCalendar(
          "SAVE-AI",
          calendarColor: Colors.orange,
          localAccountName: "SAVE-AI",
        );
        if (result.isSuccess) {
          showInSnackBar("Created SAVE-AI Calendar");
          _retrieveCalendars();
        } else {
          showInSnackBar("Use ${_calendars.last.name} for calendar");
        }
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void _createCalendarEvent(String stime, String etime, String inviter_name,
      String invitee_name) async {
    String cal_id = '';

    await _retrieveCalendars();

    _calendars.forEach((Calendar cal) {
      print(cal.name);
      if (cal.name == "SAVE-AI") {
        cal_id = cal.id;
        print(cal_id);
      }
    });

    if (cal_id == '') {
      cal_id = _calendars.last.id;
    }

    List<Attendee> _attendees = <Attendee>[];
    List<Reminder> _reminders = <Reminder>[];

    _event = Event(cal_id,
        start: DateTime.parse(stime),
        end: DateTime.parse(etime),
        title: "SAVE-AI Meeting",
        description: "Meeting of $inviter_name and $invitee_name.");

    _reminders.add(Reminder(minutes: 30));
    _reminders.add(Reminder(minutes: 15));
    // _attendees.add(Attendee(name: inviter_name));
    // _attendees.add(Attendee(name: invitee_name));

    _event.reminders = _reminders;
    // _event.attendees = _attendees;

    String _link = await getZoomLink();

    _event.location = _link;
    _event.url = Uri.dataFromString(_link);

    var createEventResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(_event);
    if (createEventResult.isSuccess) {
      print('event success');
    } else {
      print('event failed');
      print(createEventResult.errorMessages);
    }
  }

  getFriends() async {
    Response response;
    Dio dio = new Dio();
    response = await dio.get(
        "https://save-ai-api-staging.herokuapp.com/api/db/v_friend?me_id=$UserID_Internal");

    print(response);

    try {
      List rep = response.data["response"]["data"];
      print(rep.length);
      setState(() {
        friends = List.generate(
            rep.length,
            (index) => {
                  "name": rep[index]["display_name"],
                  "dp": rep[index]["pictures"][0],
                  "status": rep[index]["user_status"]
                });
      });
    } catch (e) {
      friends = [];
    }
  }

  getCal() async {
    await getCalendar();
    setState(() {
      meetings = calendar;
    });
  }

  getSch() async {
    await getScheduleRec();
    setState(() {
      schedule = schedule_rec;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  Widget calendarCard(Map meeting) {
    return Container(
      height: 167,
      margin: EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkToFileImage(
                    url: meeting['inviter'] == UserID_Internal
                        ? meeting['invitee_pictures']
                        : meeting['inviter_pictures'],
                    file: null),
                radius: 25,
              ),

              // leading: CircleAvatar(
              //   backgroundImage: NetworkToFileImage(url: rec['dp'], file: null),
              //   radius: 25,
              // ),
              title: Text(
                  meeting['inviter'] == UserID_Internal
                      ? meeting['invitee_name']
                      : meeting['inviter_name'],
                  style: GoogleFonts.asul(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF343d8f))),
              subtitle: Text(
                (meeting['inviter'] == UserID_Internal
                    ? "Invite sent to: " + meeting['invitee_name']
                    : "Invite received from: " + meeting['inviter_name']),
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 14),
              ),
              trailing: Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: (meeting["status"].toString() == 'pending')
                          ? Color(0xFFff8552)
                          : (meeting["status"].toString() == 'accepted'
                              ? Colors.green
                              : Colors.red),
                      width: 2),
                ),
                child: Text(
                  meeting["status"].toString().toUpperCase(),
                  style: TextStyle(
                    color: (meeting["status"].toString() == 'pending')
                        ? Color(0xFFff8552)
                        : (meeting["status"].toString() == 'accepted'
                            ? Colors.green
                            : Colors.red),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 15),
                    SizedBox(width: 10),
                    Text(
                      "Zoom Meeting",
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 15),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.access_time,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('E, MMMM d,', 'en_US').add_jm().format(
                          DateTime.parse(DateTime.parse(meeting["start_time"])
                                  .toString()
                                  .substring(0, 10) +
                              " " +
                              DateTime.parse(meeting["start_time"])
                                  .toString()
                                  .substring(11, 16))),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 15),
                    ),
                  ],
                )),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                meeting['inviter'] != UserID_Internal
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FlatButton(
                            child: Text(
                              "Accept",
                              style: TextStyle(
                                color: Color(0xFFff8552),
                              ),
                            ),
                            // color: Theme.of(context).accentColor,
                            // color: Colors.greenAccent,
                            onPressed: () async {
                              await updateCalendar(
                                  "accepted", meeting["calendar_id"]);
                              _createCalendarEvent(
                                  meeting['start_time'],
                                  meeting['end_time'],
                                  meeting['inviter_name'],
                                  meeting['invitee_name']);
                              showInSnackBar("Added the event to calendar");
                              setState(() {
                                _refreshController_cal.requestRefresh();
                              });
                            },
                          ),
                          SizedBox(width: 100),
                          FlatButton(
                            child: Text(
                              "Reject",
                              style: TextStyle(
                                color: Color(0xFFff8552),
                              ),
                            ),
                            // color: Theme.of(context).accentColor,
                            // color: Colors.redAccent,
                            onPressed: () {
                              updateCalendar(
                                  "rejected", meeting["calendar_id"]);
                              setState(() {
                                _refreshController_cal.requestRefresh();
                              });
                            },
                          ),
                        ],
                      )
                    : FlatButton(
                        textColor: const Color(0xFFff8552),
                        child: Text(
                          "Add to calender",
                        ),
                        // color: Theme.of(context).accentColor,
                        // color: Colors.redAccent,
                        onPressed: () {
                          _createCalendarEvent(
                              meeting['start_time'],
                              meeting['end_time'],
                              meeting['inviter_name'],
                              meeting['invitee_name']);

                          showInSnackBar("Added the meeting to calendar");
                        },
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget meetingCard(Map rec) {
    String location = '';

    if (rec["location_city"] == null) {
      location = 'N/A';
    } else {
      List<String> loc = rec["location_city"].toString().split('_');
      if (loc.length == 0) {
        location = rec["location_city"];
      } else if (loc.length == 1) {
        loc[0] == 'null' ? location = 'N/A' : location = loc[0];
      } else if (loc.length == 2) {
        loc[0] == 'null' ? location = 'N/A' : location = loc[1] + ', ' + loc[0];
      } else if (loc.length == 3) {
        loc[0] == 'null' ? location = 'N/A' : location = loc[2] + ', ' + loc[0];
      }
    }

    return Container(
      height: 167,
      margin: EdgeInsets.all(8),
      child: Card(
        elevation: 10,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14.0))),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // BackdropFilter(
            //  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20)),

            ListTile(
              leading: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20.0,
                  sigmaY: 20.0,
                ),
                child: CircleAvatar(
                  backgroundImage:
                      NetworkToFileImage(url: rec['dp'], file: null),
                  radius: 25,
                ),
              ),

              // leading: CircleAvatar(
              //   backgroundImage: NetworkToFileImage(url: rec['dp'], file: null),
              //   radius: 25,
              // ),
              title: Text(rec['name'],
                  style: GoogleFonts.asul(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF343d8f))),
              subtitle: Text(
                "Matching Rating: " + rec["ai"].toString(),
                style: TextStyle(
                    color: Colors.black.withOpacity(0.6), fontSize: 14),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 15),
                    SizedBox(width: 10),
                    Text(
                      location,
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 14),
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.access_time,
                      size: 15,
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat('E, MMMM d,', 'en_US')
                          .add_jm()
                          .format(DateTime.parse(getMeetingTime(rec))),
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.6), fontSize: 14),
                    ),
                  ],
                )),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  textColor: const Color(0xFFff8552),
                  onPressed: () async {
                    List availability = rec["matched_availability"][0];
                    DateTime tday = DateTime.now();
                    DateTime appointment;
                    int hours = (availability[0] / 60).round();
                    int weekday = (hours / 24).floor();
                    int hour = hours % 24;
                    print({weekday, hour});
                    if (tday.weekday > weekday) {
                      appointment = tday
                          .add(Duration(days: 7 - (tday.weekday - weekday)));
                    } else if (tday.weekday < weekday) {
                      appointment =
                          tday.add(Duration(days: weekday - tday.weekday));
                    } else {
                      appointment = tday;
                    }
                    String stime =
                        "${appointment.year.toString()}-${appointment.month.toString().padLeft(2, '0')}-${appointment.day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:00:00";
                    String etime =
                        "${appointment.year.toString()}-${appointment.month.toString().padLeft(2, '0')}-${appointment.day.toString().padLeft(2, '0')} ${(hour + 1).toString().padLeft(2, '0')}:00:00";

                    print(stime);

                    await addCalendar(rec["user_id"], stime, etime);

                    setState(() {
                      _refreshController_sch.requestRefresh();
                    });
                  },
                  child: const Text('Confirm'),
                ),
                SizedBox(
                  width: 100,
                ),
                FlatButton(
                  textColor: const Color(0xFFff8552),
                  onPressed: () {
                    // Perform some action
                  },
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _retrieveCalendars();
    //_createCalendar();

    // getFriends();
    // getCal();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);

    // _tabController.addListener(() {
    //   print(_tabController.index);
    //   if (_tabController.index == 0) {
    //     getSch();
    //   } else if (_tabController.index == 1) {
    //     getCal();
    //   } else if (_tabController.index == 2) {
    //     getFriends();
    //   }
    // });
  }

  String getMeetingTime(Map rec) {
    List availability = rec["matched_availability"][0];
    DateTime tday = DateTime.now();
    DateTime appointment;
    int hours = (availability[0] / 60).round();
    int weekday = (hours / 24).floor();
    int hour = hours % 24;
    print({weekday, hour});
    if (tday.weekday > weekday) {
      appointment = tday.add(Duration(days: 7 - (tday.weekday - weekday)));
    } else if (tday.weekday < weekday) {
      appointment = tday.add(Duration(days: weekday - tday.weekday));
    } else {
      appointment = tday;
    }
    String stime =
        "${appointment.year.toString()}-${appointment.month.toString().padLeft(2, '0')}-${appointment.day.toString().padLeft(2, '0')} ${hour.toString().padLeft(2, '0')}:00:00";
    String etime =
        "${appointment.year.toString()}-${appointment.month.toString().padLeft(2, '0')}-${appointment.day.toString().padLeft(2, '0')} ${(hour + 1).toString().padLeft(2, '0')}:00:00";

    return (stime);
  }

  void _onRefresh_sch() async {
    // monitor network fetch
    try {
      await getSch();
      if (schedule.length == 0) {
        setState(() {
          isSchEmpty = true;
        });
        _refreshController_sch.refreshToIdle();
      } else {
        setState(() {
          isSchEmpty = false;
        });
        _refreshController_sch.refreshCompleted();
      }
    } catch (error) {
      _refreshController_sch.refreshFailed();
    }
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  void _onLoading_sch() async {
    // monitor network fetch
    try {
      await getSch();
      if (schedule.length == 0) {
        setState(() {
          isSchEmpty = true;
        });
        _refreshController_sch.loadNoData();
      } else {
        setState(() {
          isSchEmpty = false;
        });
        _refreshController_sch.loadComplete();
      }
    } catch (error) {
      _refreshController_sch.loadFailed();
    }
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // if (mounted) setState(() {});
  }

  void _onRefresh_cal() async {
    // monitor network fetch
    try {
      await getCal();
      if (meetings.length == 0) {
        setState(() {
          isCalEmpty = true;
        });
        _refreshController_cal.refreshToIdle();
      } else {
        setState(() {
          isCalEmpty = false;
        });
        _refreshController_cal.refreshCompleted();
      }
    } catch (error) {
      _refreshController_cal.refreshFailed();
    }
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  void _onLoading_cal() async {
    // monitor network fetch
    try {
      await getCal();
      if (meetings.length == 0) {
        setState(() {
          isCalEmpty = true;
        });
        _refreshController_cal.loadNoData();
      } else {
        setState(() {
          isCalEmpty = false;
        });
        _refreshController_cal.loadComplete();
      }
    } catch (error) {
      _refreshController_cal.loadFailed();
    }
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // if (mounted) setState(() {});
  }

  void _onRefresh_friends() async {
    // monitor network fetch
    try {
      await getFriends();
      if (friends.length == 0) {
        _refreshController_friends.refreshToIdle();
      } else {
        _refreshController_friends.refreshCompleted();
      }
    } catch (error) {
      _refreshController_friends.refreshFailed();
    }
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
  }

  void _onLoading_friends() async {
    // monitor network fetch
    try {
      await getFriends();
      if (friends.length == 0) {
        _refreshController_friends.loadNoData();
      } else {
        _refreshController_friends.loadComplete();
      }
    } catch (error) {
      _refreshController_friends.loadFailed();
    }
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    // if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFfdf6ee),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfdf6ee),
        // title: TextField(
        //   decoration: InputDecoration.collapsed(
        //     hintText: 'Search',
        //   ),
        // ),
        title: Text(
          "SAVE",
          style: GoogleFonts.cormorant(
              color: Color(0xFFff8552),
              fontSize: 25,
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: Color(0xFFff8552),
            ),
            onPressed: () {
              Navigate.pushPage(context, SchedulePage());
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFff8552),
          labelColor: Color(0xFFff8552),
          unselectedLabelColor: Colors.black54,
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "Introduction",
            ),
            Tab(
              text: "Meeting",
            ),
            // Tab(
            //   text: "Message",
            // ),
            Tab(
              text: "Matches",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Stack(
            children: [
              SmartRefresher(
                enablePullDown: true,
                // enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController_sch,
                onRefresh: _onRefresh_sch,
                onLoading: _onLoading_sch,
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Divider(),
                      ),
                    );
                  },
                  itemCount: schedule.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map rec = schedule[index];
                    return meetingCard(rec);
                  },
                ),
              ),
              isSchEmpty
                  ? Center(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Text(
                          'No introduction recommendations.',
                          style: GoogleFonts.pangolin(
                              fontSize: 22, color: Color(0xFF343d8f)),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Please (re)select your availability.  ',
                              style: GoogleFonts.pangolin(
                                  fontSize: 22, color: Color(0xFF343d8f)),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFFff8552),
                            ),
                          ],
                        )
                      ],
                    ))
                  : Container(),
            ],
          ),

          Stack(
            children: [
              SmartRefresher(
                enablePullDown: true,
                // enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController_cal,
                onRefresh: _onRefresh_cal,
                onLoading: _onLoading_cal,
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Divider(),
                      ),
                    );
                  },
                  itemCount: meetings.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map rec = meetings[index];
                    return calendarCard(rec);
                  },
                ),
              ),
              isCalEmpty
                  ? Center(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Text(
                          'No calendar events.',
                          style: GoogleFonts.pangolin(
                              fontSize: 24, color: Color(0xFF343d8f)),
                        ),
                        Text(
                          'Please come back soon :)',
                          style: GoogleFonts.pangolin(
                              fontSize: 24, color: Color(0xFF343d8f)),
                        ),
                      ],
                    ))
                  : Container(),
            ],
          ),

          Stack(
            children: [
              SmartRefresher(
                enablePullDown: true,
                // enablePullUp: true,
                header: WaterDropHeader(),
                controller: _refreshController_friends,
                onRefresh: _onRefresh_friends,
                onLoading: _onLoading_friends,
                child: ListView.separated(
                  padding: EdgeInsets.all(10),
                  separatorBuilder: (BuildContext context, int index) {
                    return Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width / 1.3,
                        child: Divider(),
                      ),
                    );
                  },
                  itemCount: friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map friend = friends[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkToFileImage(url: friend['dp'], file: null),
                          radius: 25,
                        ),
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.INFO,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Tips',
                            desc: 'Are you sure you want to unmatch?',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {},
                          )..show();
                        },
                        contentPadding: EdgeInsets.all(0),
                        title: Text(friend['name']),
                        subtitle: Text(friend['status']),
                        trailing: FlatButton(
                          child: Text(
                            "Starred",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          // color: Theme.of(context).accentColor,
                          color: Colors.blueAccent,
                          onPressed: () {},
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
              isFriendsEmpty
                  ? Center(
                      child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                        ),
                        Text(
                          'No matches yet.',
                          style: GoogleFonts.pangolin(
                              fontSize: 24, color: Color(0xFF343d8f)),
                        ),
                        Text(
                          'Please come back soon :)',
                          style: GoogleFonts.pangolin(
                              fontSize: 24, color: Color(0xFF343d8f)),
                        ),
                      ],
                    ))
                  : Container(),
            ],
          ),

          // ListView.separated(
          //   padding: EdgeInsets.all(10),
          //   separatorBuilder: (BuildContext context, int index) {
          //     return Align(
          //       alignment: Alignment.centerRight,
          //       child: Container(
          //         height: 0.5,
          //         width: MediaQuery.of(context).size.width / 1.3,
          //         child: Divider(),
          //       ),
          //     );
          //   },
          //   itemCount: chats.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     Map chat = chats[index];
          //     return ChatItem(
          //       dp: chat['dp'],
          //       name: chat['name'],
          //       isOnline: chat['isOnline'],
          //       counter: chat['counter'],
          //       msg: chat['msg'],
          //       time: chat['time'],
          //     );
          //   },
          // ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Navigate.pushPage(context, SchedulePage());
      //   },
      // ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
