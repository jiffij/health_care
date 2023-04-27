import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_login/yannie_version/color.dart';
import 'package:simple_login/yannie_version/widget/toggle.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../helper/firebase_helper.dart';

class myBooking extends StatefulWidget {
  const myBooking({
    Key? key,
    required this.serverData
  }) : super(key: key);

  final List serverData;

  @override
  State<myBooking> createState() => _HomeState();
}

class _HomeState extends State<myBooking> {

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    for (var booking in widget.serverData) {
      int today = int.parse(todayDateFormatter());
      if (int.parse(booking[0])>today) upcoming.add(booking);
      else completed.add(booking);
    }
  }

  bool ready = false;
  int? _toggleValue = 0;
  List upcoming = [];
  List completed = [];
  List canceled = [["20230522", "20:00", "Mike Jackson"]];

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
            padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
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
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
            ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Icon(Icons.arrow_back, size: 23,color: themeColor,)
            )),
          leadingWidth: 95,
        ),
        body: SafeArea(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 30,),
              ToggleSwitch(
                totalSwitches: 3,
                initialLabelIndex: _toggleValue,
                minWidth: MediaQuery.of(context).size.width*0.8,
                labels: ['Upcoming', 'Completed', 'Canceled'],
                radiusStyle: true,
                cornerRadius: 10,
                customTextStyles: [],
                activeBgColor: [lighttheme, lighttheme, lighttheme],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.white,
                onToggle:(index) {
                  setState(() {
                    _toggleValue = index;
                  });
                },
              ),
              
              Expanded(child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding, horizontal: defaultHorPadding/2),
                    scrollDirection: Axis.vertical,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    primary: true,
                    itemCount: _toggleValue == 0? upcoming.length : _toggleValue == 1? completed.length : canceled.length,
                    itemBuilder: (context, index) => _toggleValue == 0? AppointmentCard(appointment: upcoming[index], type: 0) : _toggleValue == 1? AppointmentCard(appointment: completed[index], type: 1) : AppointmentCard(appointment: canceled[index], type: 2),
              ),)
            ]
          )
        ),
    );
  }
}


class AppointmentCard extends StatefulWidget {

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();

  const AppointmentCard({
    Key? key,
    required this.appointment,
    required this.type
  }) : super(key: key);
  final List appointment;
  final int type;

}

class _AppointmentCardState extends State<AppointmentCard> {
  
  @override
  Widget build(BuildContext context) {
    final List<String> spec = ["Allergy and Immunology",
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

    DateTime bookingTime = toDateTime(widget.appointment[0], widget.appointment[1]);
    bool disable = (bookingTime.compareTo(DateTime.now()) >= 0);

    return Container(
      width: size.width,
      height: widget.type<=1? 225: 150,
      margin: const EdgeInsets.only(top: defaultVerPadding/2),
      padding: EdgeInsets.all(defaultHorPadding/1.5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [BoxShadow(
                      offset: const Offset(0, 8),
                      blurRadius: 5,
                      color: goodColor.withOpacity(0.13),
                    ),]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dr. ${widget.appointment[2]}', style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: widget.type == 0?Color.fromARGB(255, 94, 235, 117).withOpacity(0.4):widget.type == 1?Colors.yellow.withOpacity(0.4):Colors.red.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  widget.type == 0?"Confirmed":widget.type == 1?"Completed":"Canceled",
                  style: TextStyle(
                    color: widget.type == 0?Color.fromARGB(255, 26, 132, 49):widget.type == 1?Color.fromARGB(255, 162, 128, 25):Color.fromARGB(255, 144, 21, 21),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 5),
          Text(spec[r], style: GoogleFonts.comfortaa(color: Color(0xff91919F), fontSize: 16),),
          SizedBox(height: 5),
          Divider(color: lighttheme,),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month_rounded, color: lighttheme,size: 23,),
                  SizedBox(width: 10,),
                  Text(date, style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 16),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.schedule_rounded, color: lighttheme,size: 23,),
                  SizedBox(width: 10,),
                  Text(time, style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 16),)
                ],
              )
            ],
          ),
          widget.type <= 1?SizedBox(height: 25,):SizedBox(height: 0,),
          widget.type == 0?
          ElevatedButton(
            onPressed: (){},
            style: ButtonStyle(
              overlayColor: disable ?MaterialStatePropertyAll(Colors.transparent): MaterialStatePropertyAll(lighttheme.withOpacity(0.1)),
              minimumSize: MaterialStatePropertyAll(Size.fromHeight(20)),
              backgroundColor: disable? MaterialStatePropertyAll(Color.fromARGB(255, 194, 194, 194)):MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
              side: MaterialStatePropertyAll(BorderSide(color: disable? Colors.transparent:themeColor)),
              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15))
            ),
            child: Text("Join Video Call", style: GoogleFonts.comfortaa(color: disable? Colors.white:lighttheme, fontSize: 18),)
          ):
          widget.type == 1?
          ElevatedButton(
            onPressed: (){},
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              overlayColor: MaterialStatePropertyAll(lighttheme.withOpacity(0.1)),
              minimumSize: MaterialStatePropertyAll(Size.fromHeight(20)),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
              side: MaterialStatePropertyAll(BorderSide(color: themeColor)),
              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 15))
            ),
            child: Text("View Report", style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),)
          ):Container()
        ]
      ),
    );
  }
}

String todayDateFormatter() {
  DateTime today = DateTime.now();
  String year = today.year.toString();
  String month = today.month < 10? "0" + today.month.toString() :today.month.toString();
  String day = today.day < 10? "0" + today.day.toString() :today.day.toString();
  return year+month+day;
}

String timeFormatter(String time) {
  String hour = time.substring(0, 2);
  int hourInInt = int.parse(hour);

  if (hourInInt>12){
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
  String year = date.substring(0,4);
  String month = date.substring(4, 6);
  String day = date.substring(6);
  return day+"/"+month+"/"+year;
}

DateTime toDateTime(String date, String time) {
  int year = int.parse(date.substring(0,4));
  int month = int.parse(date.substring(4,6));
  int day = int.parse(date.substring(6));
  int hour = int.parse(time.substring(0,2));
  int min = int.parse(time.substring(3,5));
  return DateTime(year, month, day, hour, min);
}
