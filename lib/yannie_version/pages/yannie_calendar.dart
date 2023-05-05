import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:collection';

import 'package:intl/intl.dart';

import '../../helper/firebase_helper.dart';
import '../color.dart';
import '../widget/event_for_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // DateTime? _rangeStart;
  // DateTime? _rangeEnd;
  List appointments = [];
  dynamic events;
  bool ready = false;

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

  // List<Event> _getEventsForRange(DateTime start, DateTime end) {
  //   // Implementation example
  //   final days = daysInRange(start, end);

  //   return [
  //     for (final d in days) ..._getEventsForDay(d),
  //   ];
  // }
  DateTime toDateTime(String date, String time) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(4, 6));
  int day = int.parse(date.substring(6));
  int hour = int.parse(time.substring(0, 2));
  int min = int.parse(time.substring(3, 5));
  return DateTime(year, month, day, hour, min);
}


  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);

      showModalBottomSheet(
        context: context,
        enableDrag: true,
        backgroundColor: bgColor,
        useSafeArea: true,
        isScrollControlled: true,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height*0.65,
          minHeight: MediaQuery.of(context).size.height*0.3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        builder: (_) => StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white, width: 3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat("d MMMM y, EEEE").format(selectedDay),
                      style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Scrollbar(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 10,
                      left: defaultHorPadding/2,
                      right: defaultHorPadding/2,
                      bottom: 10,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height*0.65, // set a max height for the ListView
                          child: Scrollbar(child: ListView.builder(
                            itemCount: _selectedEvents.value.length, // replace with your actual item count
                            itemBuilder: (context, index) => Material(
                              color: Colors.transparent,
                              child: InkWell(
                                splashColor: lighttheme.withOpacity(0.8),
                                splashFactory: InkRipple.splashFactory,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: defaultHorPadding/3, vertical: defaultVerPadding/3),
                                child: Ink(
                                padding: EdgeInsets.symmetric(horizontal: defaultHorPadding, vertical: defaultVerPadding),
                                height: 160,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 8),
                                      blurRadius: 5,
                                      color: goodColor.withOpacity(0.13),
                                    ),
                                  ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text("Dr. ${_selectedEvents.value[index].doctorName}", style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 18),),
                                    SizedBox(height: 10,),
                                    Text(_selectedEvents.value[index].specialty, style: GoogleFonts.comfortaa(color: Color(0xff91919F), fontSize: 15),),
                                    SizedBox(height: 5,),
                                    Divider(
                                      color: lighttheme,
                                    ),
                                    SizedBox(height: 10,),
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
                                              DateFormat("dd/MM/yyy").format(selectedDay),
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
                                              _selectedEvents.value[index].time,
                                              style: GoogleFonts.comfortaa(
                                                  color: lighttheme, fontSize: 16),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ))
                            ))
                          ),)
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }   
  }

  // void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
  //   setState(() {
  //     _selectedDay = null;
  //     _focusedDay = focusedDay;
  //     _rangeStart = start;
  //     _rangeEnd = end;
  //     _rangeSelectionMode = RangeSelectionMode.toggledOn;
  //   });

  //   // `start` or `end` could be null
  //   if (start != null && end != null) {
  //     _selectedEvents.value = _getEventsForRange(start, end);
  //   } else if (start != null) {
  //     _selectedEvents.value = _getEventsForDay(start);
  //   } else if (end != null) {
  //     _selectedEvents.value = _getEventsForDay(end);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
       appBar: AppBar(
                  //title: Text('Search For Doctor'),
                  elevation: 0,
                  toolbarHeight: 80,
                  backgroundColor: lighttheme,
                  titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500)),
                  centerTitle: true,
                  title: Text('My Calendar'),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                  
                ),
      body: !ready? Center(child: LoadingAnimationWidget.inkDrop(color: lighttheme, size: 50),
): Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(height: size.height*0.07,),
            
            //the calendar
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultHorPadding/1.5, vertical: defaultVerPadding),
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
            SizedBox(height: MediaQuery.of(context).size.height*0.012),
            guide(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
          ],
        ),
    );
  }
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