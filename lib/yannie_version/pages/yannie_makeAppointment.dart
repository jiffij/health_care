import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/alert.dart';
import 'package:simple_login/yannie_version/pages/yannie_home.dart';
import 'package:simple_login/yannie_version/widget/navigator.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helper/firebase_helper.dart';
import '../../modify_timeslot_package/time_slot_from_list.dart';
import '../color.dart';
import '../widget/event_for_calendar.dart';

// Other files


class MakeAppointment extends StatefulWidget {
  final List doctor;

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

  

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
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

      //_selectedEvents.value = _getEventsForDay(selectedDay);
    //}
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      //showDragHandle: true,
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
            String message = "Please confirm your timeslot:\n\n"+DateFormat("d MMMM y  - ").add_jm().format(selectTime);
            final result = await showConfirmDialog(context, message);
            if (result == true) 
            {makeAppointment();
            await showSuccessDialog(context, "Booking Success");
            Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomNav()),);}
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
      child: Scaffold(
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
                      Text('Family Medicine', style: GoogleFonts.comfortaa(color: Color(0xff91919F), fontSize: 15),),
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
                firstDay: kFirstDay,
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
                onDaySelected: _onDaySelected,
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
  
  // Todo: Decide hard code access data one by one
  bool tlshow = false;
  List<List> timeslotslist = [
      ['00:00', true, '00:20', true, '00:40', true],
      ['01:00', true, '01:20', true, '01:40', true],
      ['02:00', true, '02:20', true, '02:40', true],
      ['03:00', true, '03:20', true, '03:40', true],
      ['04:00', true, '04:20', true, '04:40', true],
      ['05:00', true, '05:20', true, '05:40', true],
      ['06:00', true, '06:20', true, '06:40', true],
      ['07:00', true, '07:20', true, '07:40', true],
      ['08:00', true, '08:20', true, '08:40', true],
      ['09:00', true, '09:20', true, '09:40', true],
      ['10:00', true, '10:20', true, '10:40', true],
      ['11:00', true, '11:20', true, '11:40', true],
      ['12:00', true, '12:20', true, '12:40', true],
      ['13:00', true, '13:20', true, '13:40', true],
      ['14:00', true, '14:20', true, '14:40', true],
      ['15:00', true, '15:20', true, '15:40', true],
      ['16:00', true, '16:20', true, '16:40', true],
      ['17:00', true, '17:20', true, '17:40', true],
      ['18:00', true, '18:20', true, '18:40', true],
      ['19:00', true, '19:20', true, '19:40', true],
      ['20:00', true, '20:20', true, '20:40', true],
      ['21:00', true, '21:20', true, '21:40', true],
      ['22:00', true, '22:20', true, '22:40', true],
      ['23:00', true, '23:20', true, '23:40', true],
    ];

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    Map<String, dynamic>? data = await readFromServer('doctor/${widget.doctor[1]}');
    setState(() {
      print(data);
    });
  }

  void changeTimeslot(String newTimeslot) {
    selected_timeslot = newTimeslot;
    setState(() {});
  }

  // Pop out when selecting the unavailable tiimeslot
  void warning_message() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Oops! The timeslot you selected is unavailable!'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Exit'),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  // Pop out before the user finalize their booking
  void confirm_message() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
            'Please confirm your booking timeslot:\n${getDate(_focusedDay)} - $selected_timeslot',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton(
            onPressed: () => makeAppointment(),
            child: const Text('Confirm'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'Exit'),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  // Pop out successful after the user finalize their booking
  void successful_message() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text(
            'Your booking of appintment:\n${getDate(_focusedDay)} - $selected_timeslot\n is successful!',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void changeTimeslotlist() {
    tlshow = !tlshow;
    setState(() {});
  }

  void checkExist(String date) async {
    List<List> templist = [
      ['00:00', true, '00:20', true, '00:40', true],
      ['01:00', true, '01:20', true, '01:40', true],
      ['02:00', true, '02:20', true, '02:40', true],
      ['03:00', true, '03:20', true, '03:40', true],
      ['04:00', true, '04:20', true, '04:40', true],
      ['05:00', true, '05:20', true, '05:40', true],
      ['06:00', true, '06:20', true, '06:40', true],
      ['07:00', true, '07:20', true, '07:40', true],
      ['08:00', true, '08:20', true, '08:40', true],
      ['09:00', true, '09:20', true, '09:40', true],
      ['10:00', true, '10:20', true, '10:40', true],
      ['11:00', true, '11:20', true, '11:40', true],
      ['12:00', true, '12:20', true, '12:40', true],
      ['13:00', true, '13:20', true, '13:40', true],
      ['14:00', true, '14:20', true, '14:40', true],
      ['15:00', true, '15:20', true, '15:40', true],
      ['16:00', true, '16:20', true, '16:40', true],
      ['17:00', true, '17:20', true, '17:40', true],
      ['18:00', true, '18:20', true, '18:40', true],
      ['19:00', true, '19:20', true, '19:40', true],
      ['20:00', true, '20:20', true, '20:40', true],
      ['21:00', true, '21:20', true, '21:40', true],
      ['22:00', true, '22:20', true, '22:40', true],
      ['23:00', true, '23:20', true, '23:40', true],
    ];

    // The booking is unavailable 1 hour before the required meeting timeslot
    var time = getOneHourAfterAsServer(DateTime.now());
    bool timecheck = false;
    if (_selectedDay!.year <= DateTime.now().year) {
      print('Year');
      print(_selectedDay!.year);
      print(DateTime.now().year);
      if (_selectedDay!.month <= DateTime.now().month) {
        print('Month:');
        print(_selectedDay!.month);
        print(DateTime.now().month);
        print('Day:');
        print(_selectedDay!.day);
        print(DateTime.now().day);
        print('Hour:');
        print(time);
        // Passed day
        if (_selectedDay!.day < DateTime.now().day) {
          for (int i = 0; i < templist.length; i++) {
            for (int j = 0; j < templist[i].length; j = j + 2) {
              templist[i][j+1] = 'false';
            }
          }
        }
        // Selected day = today
        else if (_selectedDay!.day == DateTime.now().day) {
          for (int i = 0; i < templist.length; i++) {
            for (int j = 0; j < templist[i].length; j = j + 2) {
              print(templist[i][j]);
              if (templist[i][j] != time)
              {
                templist[i][j+1] = 'false';
              }
              else {
                timecheck = true;
                break;
              }
            }
            if (timecheck == true) {
              break;
            }
          }
        }
      }
    }
    List<String> existdatelist = await getColId('doctor/${widget.doctor[1]}/appointment');
    print(existdatelist);
    Map<String, dynamic>? existtimemap;
    // Get current exist datelist if available
    if (existdatelist.isNotEmpty) {
      for (var existdate in existdatelist) {
        if (existdate == dateToServer(_selectedDay!)) {
          print(existdate);
          existtimemap = await readFromServer('doctor/${widget.doctor[1]}/appointment/$existdate');
          print(existtimemap);
        }
      }
      if (existtimemap != null) {
        final keyList = existtimemap.keys.toList();
        for (var existtime in keyList) {
          for (int i = 0; i < templist.length; i++) {
            for (int j = 0; j < templist[i].length; j = j + 2) {
              // The timeslot has been booked
              if (existtime == templist[i][j]) {
                templist[i][j + 1] = 'false';
              }       
            }
          }
        }
      }
    }
    //print('checkpoint 1');
    setState(() {timeslotslist = templist;});
    //print(timeslotslist);
  }

  String getDate(DateTime date) {
    var formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);
    return formattedDate.toString();
  }

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
    return formattedDate.toString();
  }

  String getOneHourAfterAsServer(DateTime date) {
    var tempH = date.hour;
    var tempM = date.minute;
    tempH = tempH + 1;
    var hour = tempH.toString();
    if (tempM >= 0 && tempM <= 20) {
      tempM = 00;
    }
    else if (tempM >= 21 && tempM <= 40) {
      tempM = 20;
    }
    else {
      tempM = 40;
    }
    var minute = tempM.toString();
    hour = '$hour:$minute';
    return hour.toString();
  }

  void makeAppointment() {
    var uid = getUID();
    var date = dateToServer(_selectedDay!);
    var time = DateFormat("HH:mm").format(selectTime);
    writeToServer('patient/$uid/appointment/$date', {
      time: {
        'doctorID': widget.doctor[1],
        'description': '',
      }
    });
    writeToServer('doctor/${widget.doctor[1]}/appointment/$date', {
      time: {
        'patientID': uid,
        'description': '',
      }
    });
    //successful_message();
  }


  Widget calendar(double globalwidth, double globalheight) => Card(
        child: Expanded(
          child: SizedBox(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      TableCalendar(
                        weekendDays: const [DateTime.sunday],
                        rowHeight: globalheight * 0.08,
                        headerStyle: HeaderStyle(
                          headerPadding:
                              const EdgeInsets.symmetric(vertical: 2),
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextFormatter: (date, locale) =>
                              DateFormat.yMMM(locale).format(date),
                          // Calendar title style
                          titleTextStyle: TextStyle(
                              color: const Color.fromARGB(255, 74, 84, 94),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.07),
                          leftChevronIcon: Icon(
                            Icons.chevron_left,
                            color: const Color.fromARGB(255, 74, 84, 94),
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                          rightChevronIcon: Icon(
                            Icons.chevron_right,
                            color: const Color.fromARGB(255, 74, 84, 94),
                            size: MediaQuery.of(context).size.width * 0.07,
                          ),
                        ),
                        // Calendar days title style
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekendStyle:
                              TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                        ),
                        // Calendar days style
                        calendarStyle: const CalendarStyle(
                          weekendTextStyle:
                              TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                          todayDecoration: BoxDecoration(
                            color: Color.fromARGB(165, 35, 185, 59),
                            shape: BoxShape.rectangle,
                          ),
                          // highlighted color for selected day
                          selectedDecoration: BoxDecoration(
                            color: Color.fromARGB(255, 65, 95, 185),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        //calendarBuilders: CalendarBuilders(),
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2050),
                        focusedDay: _focusedDay,
                        // Todo: Calendar interatives
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        onDaySelected: (selectedDay, focusedDay) {
                          // Update the timeslotslist
                          checkExist(dateToServer(selectedDay));
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay = focusedDay; // update `_focusedDay` here as well
                            tlshow = !tlshow;
                            // print('checkpoint 3');
                            // print(_selectedDay);
                            // print(tlshow);
                            // print('checkpoint 4');
                          });
                        },
                        onPageChanged: (focusedDay) {
                          _focusedDay = focusedDay;
                        },
                      ),
                    ],
                  ),
                ),
                tlshow
                    ? timeslotlist(globalwidth, globalheight, _focusedDay)
                    : Container(),
              ],
            ),
          ),
        ),
      );

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

  Widget timeslotlist(double globalwidth, double globalheight, DateTime selectedDay) =>
      DefaultTextStyle.merge(
        child: Container(
          padding: const EdgeInsets.all(12),
          width: globalwidth,
          height: globalheight * 0.5,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            color: Color.fromARGB(255, 28, 107, 164),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => changeTimeslotlist(),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    height: globalheight * 0.06,
                    width: globalheight * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child: const Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: globalheight * 0.1,
                width: globalwidth * 0.8,
                margin: const EdgeInsets.only(left: 15),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Selected Date:',
                          style: TextStyle(
                              fontSize: 50,
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: globalheight * 0.1,
                        width: globalwidth * 0.1,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            //margin: const EdgeInsets.only(left: 12, bottom: 5),
                            height: globalheight * 0.1,
                            width: globalwidth,
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromARGB(255, 255, 255, 255),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromARGB(100, 28, 107, 164),
                                    spreadRadius: 2),
                              ],
                            ),
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text(getDate(selectedDay),
                                  style: const TextStyle(
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // The list of the timeslots
              Align(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: SizedBox(
                    height: globalheight * 0.2,
                    width: globalwidth * 0.8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 28, 107, 164),
                        boxShadow: [
                          BoxShadow(
                              color: Color.fromARGB(0, 0, 0, 0),
                              spreadRadius: 2),
                        ],
                      ),
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        // The number of itemCount depends on the number of appointment
                        // 5 is the number of appointment for testing only
                        itemCount: 24,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: globalheight * 0.04);
                        },
                        itemBuilder: (context, index) {
                          //check_exist(DateToServer(_selectedDay!));
                          return timeslot(index, globalwidth, globalheight,
                              timeslotslist[index]);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => confirm_message(),
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      height: globalheight * 0.08,
                      width: globalwidth * 0.7,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        boxShadow: const [
                          BoxShadow(
                              color: Color.fromARGB(150, 255, 255, 255),
                              spreadRadius: 2),
                        ],
                      ),
                      child: const Text('Make Appointment',
                          style: TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 28, 107, 164),
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget timeslot(
          int index, double globalwidth, double globalheight, List list) =>
      Align(
        //alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => list[1] == true
                    ? changeTimeslot(list[0])
                    : warning_message(),
                child: Container(
                  height: globalheight * 0.08,
                  width: globalwidth * 0.22,
                  padding: EdgeInsets.all(globalheight * 0.02),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: list[1] == true
                        ? list[0] == selected_timeslot
                            ? const Color.fromARGB(255, 224, 159, 31)
                            : const Color.fromARGB(255, 28, 107, 164)
                        : const Color.fromARGB(255, 123, 141, 158),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 190, 202, 218),
                          spreadRadius: 2),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${list[0]}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                ),
              ),
              SizedBox(
                width: globalwidth * 0.06,
              ),
              GestureDetector(
                onTap: () => list[3] == true
                    ? changeTimeslot(list[2])
                    : warning_message(),
                child: Container(
                  height: globalheight * 0.08,
                  width: globalwidth * 0.22,
                  padding: EdgeInsets.all(globalheight * 0.02),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: list[3] == true
                        ? list[2] == selected_timeslot
                            ? const Color.fromARGB(255, 224, 159, 31)
                            : const Color.fromARGB(255, 28, 107, 164)
                        : const Color.fromARGB(255, 123, 141, 158),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 190, 202, 218),
                          spreadRadius: 2),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${list[2]}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                ),
              ),
              SizedBox(
                width: globalwidth * 0.06,
              ),
              GestureDetector(
                onTap: () => list[5] == true
                    ? changeTimeslot(list[4])
                    : warning_message(),
                child: Container(
                  height: globalheight * 0.08,
                  width: globalwidth * 0.22,
                  padding: EdgeInsets.all(globalheight * 0.02),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: list[5] == true
                        ? list[4] == selected_timeslot
                            ? const Color.fromARGB(255, 224, 159, 31)
                            : const Color.fromARGB(255, 28, 107, 164)
                        : const Color.fromARGB(255, 123, 141, 158),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 190, 202, 218),
                          spreadRadius: 2),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('${list[4]}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 255, 255, 255))),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  
}
