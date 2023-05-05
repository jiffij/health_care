import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_login/helper/pdf_generator.dart';
import 'package:simple_login/new_doctor/pages/dViewSurvey.dart';
import 'package:simple_login/video_call/start_call.dart';
import '../color.dart';
import 'package:simple_login/yannie_version/widget/toggle.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../helper/firebase_helper.dart';
import '../../new_doctor/pages/d_diagnosis_form.dart';

class myBooking extends StatefulWidget {
  const myBooking({Key? key, required this.serverData}) : super(key: key);

  final List serverData;

  @override
  State<myBooking> createState() => _myBookingState();
}

class _myBookingState extends State<myBooking> {
  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    for (var booking in widget.serverData) {
      int today = int.parse(todayDateFormatter());
      var bookingDateTime = booking[0] + booking[1].toString().substring(0,2) + booking[1].toString().substring(3,5);
      if (int.parse(bookingDateTime) - today > -20)
        upcoming.add(booking);
      else
        completed.add(booking);
    }
    setState(() {

    });
  }

  bool ready = false;
  int? _toggleValue = 0;
  List upcoming = [];
  List completed = [];
  List canceled = [
    ["20230522", "20:00", "Mike Jackson"]
  ];

  Future<void> refresh() async {
    List appointments = [];
    setState(() {
      upcoming = [];
      completed = [];
    });
    String uid = getUID();
    List<String> existdatelist = await getColId('doctor/$uid/appointment');
    Map<String, dynamic>? existtimemap;
    if (existdatelist.isNotEmpty) {
      for (var existdate in existdatelist) {
        existtimemap =
        await readFromServer('doctor/$uid/appointment/$existdate');
        List timeList = existtimemap!.keys.toList();
        List<List> dailyAppointmentList = [];
        for (var time in timeList) {
          var id = existtimemap[time]['patientID'];
          Map<String, dynamic>? patient = await readFromServer('patient/$id');
          var dFirstname = patient?['first name'];
          var dLastname = patient?['last name'];
          var dFullname = '$dFirstname $dLastname';
          dailyAppointmentList.insert(0, [existdate, time, dFullname, id]);
        }
        //print(dailyAppointmentList);
        dailyAppointmentList = dailyAppointmentList.reversed.toList();

        for (var list in dailyAppointmentList) {
          appointments.insert(0, list);
        }
      }
      appointments = appointments.reversed.toList();
    }


    for (var booking in appointments) {
      int today = int.parse(todayDateFormatter());
      var bookingDateTime = booking[0] + booking[1].toString().substring(0,2) + booking[1].toString().substring(3,5);
      if (int.parse(bookingDateTime) - today > -20)
        upcoming.add(booking);
      else
        completed.add(booking);
    }
    print("refreshed");
    setState(() {

    });
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('My Appointments'),
        elevation: 0,
        toolbarHeight: 80,
        backgroundColor: lighttheme,
        titleTextStyle: appbar_title,
        centerTitle: true,
        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
        leading: Padding(
            padding: EdgeInsets.symmetric(
                vertical: defaultVerPadding / 2,
                horizontal: defaultHorPadding / 1.5),
            child: ElevatedButton(
                style: ButtonStyle(
                  //maximumSize: MaterialStatePropertyAll(Size(5, 5)),
                    elevation: MaterialStatePropertyAll(1),
                    shadowColor: MaterialStatePropertyAll(themeColor),
                    side: MaterialStatePropertyAll(BorderSide(
                      width: 1,
                      color: themeColor,
                    )),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20))))),
                onPressed: () => Navigator.of(context).pop(true),
                child: Icon(
                  Icons.arrow_back,
                  size: 23,
                  color: themeColor,
                ))),
        leadingWidth: 95,
      ),
      body:
      SafeArea(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 30,
                ),
                ToggleSwitch(
                  totalSwitches: 3,
                  initialLabelIndex: _toggleValue,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  labels: ['Upcoming', 'Completed', 'Canceled'],
                  radiusStyle: true,
                  cornerRadius: 10,
                  customTextStyles: [],
                  activeBgColor: [lighttheme, lighttheme, lighttheme],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.white,
                  onToggle: (index) {
                    setState(() {
                      _toggleValue = index;
                    });
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refresh,
                    child:
                  ListView.builder(
                    padding: EdgeInsets.symmetric(
                        vertical: defaultVerPadding,
                        horizontal: defaultHorPadding / 2),
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: _toggleValue == 0
                        ? upcoming.length
                        : _toggleValue == 1
                        ? completed.length
                        : canceled.length,
                    itemBuilder: (context, index) => _toggleValue == 0
                        ? AppointmentCard(appointment: upcoming[index], type: 0)
                        : _toggleValue == 1
                        ? AppointmentCard(
                        appointment: completed[index], type: 1)
                        : AppointmentCard(
                        appointment: canceled[index], type: 2),
                  ),
                  ),
                )
              ])),

    );
  }
}

class AppointmentCard extends StatefulWidget {
  @override
  State<AppointmentCard> createState() => _AppointmentCardState();

  const AppointmentCard(
      {Key? key, required this.appointment, required this.type})
      : super(key: key);
  final List appointment;
  final int type;
// final BuildContext bookContext;
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {
    final List<String> spec = [
      "Allergy and Immunology",
      "Anesthesiology",
      "Dermatology",
      "Diagnostic radiology",
      "Emergency medicine",
      "Family medicine",
      "Internal medicine",
      "Medical genetics"
    ];
    Random rnd;
    int min = 0;
    int max = 7;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    Size size = MediaQuery.of(context).size;
    String time = timeFormatter(widget.appointment[1]);
    String date = dateFormatter2(widget.appointment[0]);
    print(widget.appointment);

    DateTime bookingTime =
    toDateTime(widget.appointment[0], widget.appointment[1]);
    // bool disable = (bookingTime.compareTo(DateTime.now()) >= 0);//HACK demo purpose
    bool disable = false;

    return Container(
      width: size.width,
      height: widget.type <= 1 ? (widget.type == 0? 300 : 225) : 150,
      margin: const EdgeInsets.only(top: defaultVerPadding / 2),
      padding: EdgeInsets.all(defaultHorPadding / 1.5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 8),
              blurRadius: 5,
              color: goodColor.withOpacity(0.13),
            ),
          ]),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${widget.appointment[2]}',
                  style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: widget.type == 0
                        ? Color.fromARGB(255, 94, 235, 117).withOpacity(0.4)
                        : widget.type == 1
                        ? Colors.yellow.withOpacity(0.4)
                        : Colors.red.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    widget.type == 0
                        ? "Confirmed"
                        : widget.type == 1
                        ? "Completed"
                        : "Canceled",
                    style: TextStyle(
                      color: widget.type == 0
                          ? Color.fromARGB(255, 26, 132, 49)
                          : widget.type == 1
                          ? Color.fromARGB(255, 162, 128, 25)
                          : Color.fromARGB(255, 144, 21, 21),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Text(
              spec[r],
              style:
              GoogleFonts.comfortaa(color: Color(0xff91919F), fontSize: 16),
            ),
            SizedBox(height: 5),
            Divider(
              color: lighttheme,
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: lighttheme,
                      size: 23,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      date,
                      style: GoogleFonts.comfortaa(
                          color: lighttheme, fontSize: 16),
                    )
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      color: lighttheme,
                      size: 23,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      time,
                      style: GoogleFonts.comfortaa(
                          color: lighttheme, fontSize: 16),
                    )
                  ],
                )
              ],
            ),
            widget.type <= 1
                ? SizedBox(
              height: 25,
            )
                : SizedBox(
              height: 0,
            ),
            widget.type == 0
                ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(_createRoute(StartCall(widget.appointment[3], widget.appointment[1])));
                },
                style: ButtonStyle(
                    overlayColor: disable
                        ? MaterialStatePropertyAll(Colors.transparent)
                        : MaterialStatePropertyAll(
                        lighttheme.withOpacity(0.1)),
                    minimumSize:
                    MaterialStatePropertyAll(Size.fromHeight(20)),
                    backgroundColor: disable
                        ? MaterialStatePropertyAll(
                        Color.fromARGB(255, 194, 194, 194))
                        : MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)))),
                    side: MaterialStatePropertyAll(BorderSide(
                        color: disable ? Colors.transparent : themeColor)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15))),
                child: Text(
                  "Join Video Call",
                  style: GoogleFonts.comfortaa(
                      color: disable ? Colors.white : lighttheme,
                      fontSize: 18),
                ))
                : widget.type == 1
                ? ElevatedButton(
                onPressed: () async {
                  print(widget.appointment);
                  var time = timeRemoveColon(widget.appointment[1]);
                  var dateTime = widget.appointment[0] + time;
                  Navigator.of(context).push(_createRoute(DiagnosticForm(widget.appointment[2], dateTime, widget.appointment[3] )));
                },
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStatePropertyAll(Colors.white),
                    overlayColor:
                    MaterialStatePropertyAll(lighttheme.withOpacity(0.1)),
                    minimumSize: MaterialStatePropertyAll(Size.fromHeight(20)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
                    side: MaterialStatePropertyAll(BorderSide(color: themeColor)),
                    padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15))),
                child: Text(
                  "Publish Report",
                  style: GoogleFonts.comfortaa(
                      color: lighttheme, fontSize: 18),
                ))
                : Container(),
                if(widget.type == 0)
                  SizedBox(
                    height: 20,
                  ),
                if(widget.type == 0)
                  ElevatedButton(
                    onPressed: () {//TODO
                      Navigator.of(context).push(
                          _createRoute(viewSurvey(widget.appointment[0], widget.appointment[1], widget.appointment[2], widget.appointment[3]))
                      );
                    },
                    style: ButtonStyle(
                        overlayColor: disable
                            ? MaterialStatePropertyAll(Colors.transparent)
                            : MaterialStatePropertyAll(
                            lighttheme.withOpacity(0.1)),
                        minimumSize:
                        MaterialStatePropertyAll(Size.fromHeight(20)),
                        backgroundColor: disable
                            ? MaterialStatePropertyAll(
                            Color.fromARGB(255, 194, 194, 194))
                            : MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10)))),
                        side: MaterialStatePropertyAll(BorderSide(
                            color: disable ? Colors.transparent : themeColor)),
                        padding: MaterialStatePropertyAll(
                            EdgeInsets.symmetric(vertical: 15))),
                    child: Text(
                      "View Survey",
                      style: GoogleFonts.comfortaa(
                          color: disable ? Colors.white : lighttheme,
                          fontSize: 18),
                ))
          ]),
    );
  }
}

String todayDateFormatter() {
  // DateTime today = DateTime.now();
  // String year = today.year.toString();
  // String month =
  // today.month < 10 ? "0" + today.month.toString() : today.month.toString();
  // String day =
  // today.day < 10 ? "0" + today.day.toString() : today.day.toString();
  // String hour = today.hour.toString();
  // String minute = today.minute.toString();
  DateTime now = DateTime.now(); // get the current date and time
  String formattedDateTime = DateFormat('yyyyMMddHHmm').format(now);
  return formattedDateTime;
  // return year + month + day;
}

String timeFormatter(String time) {
  String hour = time.substring(0, 2);
  int hourInInt = int.parse(hour);

  if (hourInInt > 12) {
    hourInInt -= 12;
    String result = hourInInt.toString() + time.substring(2) + " PM";
    return result;
  }

  return time.substring(1) + " AM";
}

String dateFormatter(String date) {
  String day = date.substring(6);
  String month = date.substring(4, 6);
  switch (month) {
    case "01":
      month = "Jan";
      break;
    case "02":
      month = "Feb";
      break;
    case "03":
      month = "Mar";
      break;
    case "04":
      month = "Apr";
      break;
    case "05":
      month = "May";
      break;
    case "06":
      month = "Jun";
      break;
    case "07":
      month = "Jul";
      break;
    case "08":
      month = "Aug";
      break;
    case "09":
      month = "Sep";
      break;
    case "10":
      month = "Oct";
      break;
    case "11":
      month = "Nov";
      break;
    case "12":
      month = "Dec";
      break;
  }
  return day + "\n" + month;
}

String dateFormatter2(String date) {
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6);
  return day + "/" + month + "/" + year;
}

DateTime toDateTime(String date, String time) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(4, 6));
  int day = int.parse(date.substring(6));
  int hour = int.parse(time.substring(0, 2));
  int min = int.parse(time.substring(3, 5));
  return DateTime(year, month, day, hour, min);
}

Route _createRoute(Widget destinition) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinition,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

String timeRemoveColon(String time) {
  return time.substring(0, 2) + time.substring(3, 5);
}
