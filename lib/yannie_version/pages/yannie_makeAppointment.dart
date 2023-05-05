import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/alert.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:simple_login/yannie_version/pages/yannie_home.dart';
import 'package:simple_login/yannie_version/widget/navigator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/firebase_helper.dart';
import '../../modify_timeslot_package/time_slot_from_list.dart';
import '../color.dart';
import '../widget/event_for_calendar.dart';
import 'p_diagnostic_survey.dart';

// Other files


class MakeAppointment extends StatefulWidget {
  final List doctor; //[fullname, id, profilePic, title, fRating, exp]

  const MakeAppointment(this.doctor, {super.key});

  @override
  State<MakeAppointment> createState() =>
      _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  _MakeAppointmentState();

  
  String selected_timeslot = '';
  DateTime selectTime = DateTime.now();
 


  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  List appointments = [];
  bool ready = false;
  dynamic events;

  @override
  void initState() {
    super.initState();
    prepare();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  void prepare() async {
    await start();
    setState(() {
      ready = true;
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
          var specialty = doctor?['title'];
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
          dailyAppointmentList.insert(0, [toDateTime(day, time), time, dFullname, status, specialty]);
        }
        dailyAppointmentList = dailyAppointmentList.reversed.toList();
        for (var list in dailyAppointmentList) {
          appointments.insert(0, list);
        }
      }
      appointments = appointments.reversed.toList();
    }
    //making map
    final Map<DateTime, List<Event>> eventSource = Map.fromIterable(
      appointments, 
      key: (item) => item[0], 
      value: (item) {
        List<Event> temp = [];
        for (var booking in appointments) {
          DateTime date = booking[0];
          if (date.year == item[0].year && date.month == item[0].month && date.day == item[0].day) {
            temp.add(Event(item[0],booking[2], booking[4], booking[1], booking[3]));
          }
        }
        return temp;
      }
    );

    events = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(eventSource);
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return events[day] ?? [];
  }
  DateTime toDateTime(String date, String time) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(4, 6));
  int day = int.parse(date.substring(6));
  int hour = int.parse(time.substring(0, 2));
  int min = int.parse(time.substring(3, 5));
  return DateTime(year, month, day, hour, min);
}

Future<List> checkConflict() {
  for (var event in _selectedEvents.value) {
    if (event.dateTime.isAfter(selectTime) && event.dateTime.isBefore(selectTime.add(Duration(minutes: 30))) || event.dateTime.isAtSameMomentAs(selectTime)) {
      return Future.value([true, event]);
    }
  }
  return Future.value([false]);
}

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    //if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);

    showModalBottomSheet(
      context: context,
      enableDrag: true,
      // showDragHandle: true,
      backgroundColor: bgColor,
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height*0.7, minHeight: MediaQuery.of(context).size.height*0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50))),
      builder:  (_) => StatefulBuilder(
        builder: (context, setState) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Container(
            height: MediaQuery.of(context).size.height*0.1,
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white, width: 3))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text("Please select a timeslot on" , style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 15)),
              Text(DateFormat("d MMMM y, EEEE").format(selectedDay), style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 18)),
            ]),
            ),
          Expanded(child: Scrollbar(child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(left: defaultHorPadding, right: defaultHorPadding, bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TimesSlotGridViewFromList(
                locale: Localizations.localeOf(context).toString(),
                initTime: selectTime,
                //crossAxisCount: 4,
                selectedColor: lighttheme,
                onChange: (value) {
                  setState(() {
                    selectTime = value;
                  });
                },
                listDates: [
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 10, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 11, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 12, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 13, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 14, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 15, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 16, 30),
                  DateTime(selectedDay.year, selectedDay.month, selectedDay.day, 20, 30)
                ],
              ),
            ]
          ),
        ))),
        Container(
          height: 100,
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: defaultVerPadding, horizontal: defaultHorPadding/2),
        child: ElevatedButton(
          onPressed: () async {
            List isConflict = await checkConflict();
            if (isConflict[0]==false) {
               String message = "Please confirm your timeslot:\n\n"+DateFormat("d MMMM y  - ").add_jm().format(DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, selectTime.hour, selectTime.minute));
              final result = await showConfirmDialog(context, message);
              if (result == true) 
              {makeAppointment(context);}
            }
            else {
              Event e = isConflict[1];
              String message = "There is time conflict with an exist appointment:\n\n" + e.doctorName + "\n\n" + DateFormat("d MMMM y -- HH:mm").format(e.dateTime);
              await showAlertDialog(context, message);
            }
           
          }, 
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(lighttheme),
            shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
          ),
          child: Text("Book Now", style: GoogleFonts.comfortaa(fontSize: 18),),),
        )
        ])
      )
    );
  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: !ready? LoadingScreen(): Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
                  //title: Text('Search For Doctor'),
                  elevation: 0,
                  toolbarHeight: 80,
                  backgroundColor: lighttheme,
                  titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500)),
                  centerTitle: true,
                  title: Text('Select Timeslot'),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                  leading: Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
                    child: ElevatedButton(
                    style: ButtonStyle(
                      //minimumSize: MaterialStatePropertyAll(Size(60, 60)),
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: height*0.15,
              padding: EdgeInsets.symmetric(horizontal: defaultHorPadding*1.5, vertical: defaultVerPadding/2),
              margin: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5, horizontal: defaultHorPadding/1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 5,
                              color: goodColor.withOpacity(0.13),
                            ),]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. ${widget.doctor[0]}', style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),),
                      Text(widget.doctor[3], style: GoogleFonts.comfortaa(color: Color(0xff91919F), fontSize: 15),),
                    ],
                  ),
                  Container(
                    width: width* 0.21,
                    height: width*0.21,
                    decoration: BoxDecoration(
                      color: lighttheme.withOpacity(0.3),
                      //border: Border.all(color: themeColor),
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: NetworkImage(widget.doctor[2]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ]
              ),
            ),
            
            //the calendar
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultHorPadding/1.5, vertical: defaultVerPadding/2),
              padding: EdgeInsets.symmetric(horizontal: defaultHorPadding/3, vertical: defaultVerPadding/1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                boxShadow: [BoxShadow(
                              offset: const Offset(0, 8),
                              blurRadius: 5,
                              color: goodColor.withOpacity(0.13),
                            ),]
              ),
              child: TableCalendar<Event>(
                availableCalendarFormats: {CalendarFormat.month : 'Month'},
                firstDay: DateTime.now(),
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                weekendDays: [DateTime.sunday],
                //startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.comfortaa(fontSize: 18),
                  leftChevronIcon: Icon(Icons.chevron_left, color: lighttheme,),
                  rightChevronIcon: Icon(Icons.chevron_right, color: lighttheme,),
                  formatButtonShowsNext: false,
                  formatButtonTextStyle: GoogleFonts.comfortaa(),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.comfortaa(),
                  weekendStyle: GoogleFonts.comfortaa(color: Color.fromARGB(255, 208, 33, 33)),
                ),
                calendarStyle: CalendarStyle(
                  // Use `CalendarStyle` to customize the UI
                  markerDecoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                  markerSize: 4,
                  markerMargin: EdgeInsets.only(left: 1, right: 1, top: 5),
                  selectedDecoration: BoxDecoration(border: Border.all(color: themeColor), shape: BoxShape.circle),
                  todayDecoration: BoxDecoration(color: themeColor, shape: BoxShape.circle),
                  defaultTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black, fontSize: 14)),
                  selectedTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black, fontSize: 14)),
                  todayTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  weekendTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 208, 33, 33), fontSize: 14)),
                  weekNumberTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 14)),
                  outsideDaysVisible: false,
                ),
                onDaySelected: (selectedDay, focusedDay) => _onDaySelected(selectedDay, focusedDay),
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              )
            ),
            SizedBox(height: height*0.012),
            guide(width, height),
            //calendar(width, height),
            
            //timeslotlist(width, height, timeslotslist, _focusedDay),
          ],
        ),
      )
    );
  }

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
    return formattedDate.toString();
  }


  void makeAppointment(BuildContext context) async {
    var uid = getUID();
    var date = dateToServer(_selectedDay!);
    var time = DateFormat("HH:mm").format(selectTime);
    writeToServer('patient/$uid/appointment/$date', {
      time: {
        'doctorID': widget.doctor[1],
        'description': '',
        'status': 'confirmed'
      }
    });
    writeToServer('doctor/${widget.doctor[1]}/appointment/$date', {
      time: {
        'patientID': uid,
        'description': '',
        'status': 'confirmed'
      }
    });
    await showSuccessDialog(context, "Booking Success");
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => DiagnosticSurvey(widget.doctor[1],date, time)),//BottomNav()
    );
  }


  Widget guide(double globalwidth, double globalheight) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          //const Divider(),
          Container(
            height: globalheight * 0.04,
            //margin: const EdgeInsets.only(bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: globalheight * 0.02,
                      height: globalheight * 0.02,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(Icons.circle_outlined,
                            color: lighttheme),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' : Selected',
                          style: GoogleFonts.comfortaa(color: Colors.black)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: globalheight * 0.02,
                      height: globalheight * 0.02,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(Icons.circle,
                            color: lighttheme),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' : Today',
                          style: GoogleFonts.comfortaa(color: Colors.black)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
