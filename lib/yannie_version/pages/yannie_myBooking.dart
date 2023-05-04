import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_login/helper/alert.dart';
import 'package:simple_login/helper/loading/loading_popup.dart';
import 'package:simple_login/helper/pdf_generator.dart';
import 'package:simple_login/yannie_version/color.dart';
import 'package:simple_login/yannie_version/widget/toggle.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../helper/firebase_helper.dart';
import '../../video_call/join_call_waiting.dart';

class myBooking extends StatefulWidget {
  const myBooking({Key? key, required this.serverData}) : super(key: key);

  final List serverData;

  @override
  State<myBooking> createState() => _myBookingState();
}

class _myBookingState extends State<myBooking> {
  List<List> appointments = [];
  @override
  void initState() {
    super.initState();
    prepare();
  }

  Future<void> prepare() async {
    await start();
    setState(() {
      ready=true;
    });
  }

  Future<void> start() async {
    String uid = getUID();

    List<String> appointmentDays = await getColId('patient/$uid/appointment');
    Map<String, dynamic>? anAppointment;
    if (appointmentDays.isNotEmpty) {
      var date = DateFormat('yMMdd').format(DateTime.now());
      for (var day in appointmentDays) {
        anAppointment = await readFromServer('patient/$uid/appointment/$day');
        List timeList = anAppointment!.keys.toList();
        List<List> dailyAppointmentList = [];
        for (var time in timeList) {
          var id = anAppointment[time]['doctorID'];
          var status = anAppointment[time]['status'];
          Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
          var dFirstname = doctor?['first name'];
          var dLastname = doctor?['last name'];
          var dFullname = '$dFirstname $dLastname';
          
          if(status == 'confirmed') {
            bool isCompleted= DateTime.now().add(Duration(hours: 1)).isAfter(toDateTime(day, time));
            if (isCompleted) {
              writeToServer('patient/$uid/appointment/$day', {
                time: {
                  'doctorID': id,
                  'description': '',
                  'status': 'completed'
                }
              });
              writeToServer('doctor/$id/appointment/$day', {
                time: {
                  'patientID': uid,
                  'description': '',
                  'status': 'completed'
                }
              });
              status = 'completed';
            } 
          }
          dailyAppointmentList.insert(0, [day, time, dFullname, id, status]);
        }
        dailyAppointmentList = dailyAppointmentList.reversed.toList();
        for (var list in dailyAppointmentList) {
          appointments.insert(0, list);
        }
      }
      appointments = appointments.reversed.toList();
    }

    upcoming.clear();
    completed.clear();
    canceled.clear();

    //classify bookings
    for (var booking in appointments) {
      int today = int.parse(todayDateFormatter().substring(0,8));
      if (booking[4]=='canceled')
        canceled.add(booking);
      else if (booking[4]=='confirmed') 
        upcoming.add(booking);
      else
        completed.add(booking);
    }
  }

  void onListsChanged(List appointment) {
    setState(() {ready = false;});
    setState(() {
      upcoming.remove(appointment);
      canceled.add(appointment);
    });
    setState(() {ready = true;});
  }

  bool ready = false;
  int? _toggleValue = 0;
  List upcoming = [];
  List completed = [];
  List canceled = [
    //["20230522", "20:00", "Mike Jackson"]
  ];

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
      body: SafeArea(
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
              customTextStyles: [GoogleFonts.comfortaa(color: _toggleValue==0?Colors.white:Colors.black), GoogleFonts.comfortaa(color: _toggleValue==1?Colors.white:Colors.black), GoogleFonts.comfortaa(color: _toggleValue==2?Colors.white:Colors.black)],
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
              child: 
              !ready?
              Center(child: LoadingAnimationWidget.threeRotatingDots(color: lighttheme, size: 50)) :
              _toggleValue == 0 && upcoming.length == 0 || _toggleValue == 1 && completed.length == 0 || _toggleValue == 2 && canceled.length == 0 ?
              Center(child: Text("No appointment.", style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 18),),)
              : ListView.builder(
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
                    ? AppointmentCard(appointment: upcoming[index], type: _toggleValue!, reload: onListsChanged,)
                    : _toggleValue == 1
                        ? AppointmentCard(
                            appointment: completed[index], type: _toggleValue!, reload: onListsChanged,)
                        : AppointmentCard(
                            appointment: canceled[index], type: _toggleValue!, reload: onListsChanged,),
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
      {Key? key, required this.appointment, required this.type, required this.reload})
      : super(key: key);
  final List appointment;
  final int type;
   final Function reload;
}

class _AppointmentCardState extends State<AppointmentCard> {
  @override
  Widget build(BuildContext context) {

    //for hardcode data only//
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
    // bool disable = (bookingTime.compareTo(DateTime.now()) >= 0);//TODO demo purpose
    bool disable = false;

    return Container(
      width: size.width,
      //height: widget.type <= 1 ? 225 : 150,
      margin: const EdgeInsets.only(top: defaultVerPadding / 2),
      padding: EdgeInsets.symmetric(horizontal: defaultHorPadding / 1.5, vertical: defaultVerPadding),
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
                  'Dr. ${widget.appointment[2]}',
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

            widget.type == 0 && DateTime.now().isBefore(bookingTime.subtract(Duration(hours: 24)))
                ? ElevatedButton(
                onPressed:() async {
                  await cancelBooking(context, widget.appointment);
                  widget.reload(widget.appointment);
                },
                style: ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(lighttheme.withOpacity(0.1)),
                    minimumSize:
                    MaterialStatePropertyAll(Size.fromHeight(20)),
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)))),
                    side: MaterialStatePropertyAll(BorderSide(
                        color: lighttheme)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15))),
                child: Text(
                  "Cancel",
                  style: GoogleFonts.comfortaa(
                      color: lighttheme,
                      fontSize: 18),
                )):Container(),

                widget.type == 0 && DateTime.now().isBefore(bookingTime.subtract(Duration(hours: 24)))? SizedBox(height: 15,):SizedBox(height: 0,),

            
            widget.type == 0
                ? ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(_createRoute(JoinCallWaiting(widget.appointment[3], widget.appointment[1])));
                },
                style: ButtonStyle(
                    overlayColor: MaterialStatePropertyAll(Colors.white.withOpacity(0.1)),
                    minimumSize:
                    MaterialStatePropertyAll(Size.fromHeight(20)),
                    backgroundColor: MaterialStatePropertyAll(lighttheme),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10)))),
                    // side: MaterialStatePropertyAll(BorderSide(
                    //     color: disable ? Colors.transparent : themeColor)),
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 15))),
                child: Text(
                  "Join Video Call",
                  style: GoogleFonts.comfortaa(
                      color: Colors.white,
                      fontSize: 18),
                ))
                : widget.type == 1 //TODO PDF
                ? ElevatedButton(
                onPressed: () async {
                  pdfGen(widget.appointment);
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
                  "View Report",
                  style: GoogleFonts.comfortaa(
                      color: lighttheme, fontSize: 18),
                ))
                : Container()
          ]),
    );
  }
}

 Future<void> cancelBooking(BuildContext context, List appointment) async {
  String date = dateFormatter2(appointment[0]);
  String time = timeFormatter(appointment[1]);
  String doctor = appointment[2];
  String uid = getUID();
  DateTime datetimeform = toDateTime(appointment[0], appointment[1]);
  String serverDate = DateFormat("yyyMMdd").format(datetimeform);
  bool? result = await showConfirmDialog(context, "Confirm to cancel this appointment?\n"+"Dr. $doctor"+"\n$date -- $time");
  if(result == true) {
    Loading().show(context: context, text: "Loading...");
    writeToServer('patient/$uid/appointment/$serverDate', {
      appointment[1]: {
        'doctorID': appointment[3],
        'description': '',
        'status' : 'canceled'
      }
    });
    writeToServer('doctor/${appointment[3]}/appointment/$serverDate', {
      appointment[1]: {
        'patientID': uid,
        'description': '',
        'status' : 'canceled'
      }
    });
    Loading().hide();
    showSuccessDialog(context, "Canceled");
  }
}

String todayDateFormatter() {
  // DateTime today = DateTime.now();
  // String year = today.year.toString();
  // String month =
  // today.month < 10 ? "0" + today.month.toString() : today.month.toString();
  // String day =
  // today.day < 10 ? "0" + today.day.toString() : today.day.toString();
  // return year + month + day;
  DateTime now = DateTime.now(); // get the current date and time
  String formattedDateTime = DateFormat('yyyyMMddHHmm').format(now);
  return formattedDateTime;
}

String timeFormatter(String time) {
  String hour = time.substring(0, 2);
  int hourInInt = int.parse(hour);

  if (hourInInt > 12) {
    hourInInt -= 12;
    String result = hourInInt.toString() + time.substring(2) + " PM";
    return result;
  }
  if (hourInInt < 10) return time.substring(1) + " AM";
  return time + " AM";
  
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
