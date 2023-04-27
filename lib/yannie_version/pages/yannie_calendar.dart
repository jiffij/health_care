import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'dart:collection';

import 'package:intl/intl.dart';

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
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

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
      body: //SafeArea(
        //child: 
        Column(
          children: [
            //the calendar
            Container(
              margin: EdgeInsets.symmetric(horizontal: defaultHorPadding/1.5, vertical: defaultVerPadding),
              padding: EdgeInsets.symmetric(horizontal: defaultHorPadding/3, vertical: defaultVerPadding/3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                calendarFormat: _calendarFormat,
                rangeSelectionMode: _rangeSelectionMode,
                eventLoader: _getEventsForDay,
                //startingDayOfWeek: StartingDayOfWeek.monday,
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
                  weekendTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black, fontSize: 14)),
                  weekNumberTextStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 14)),
                  outsideDaysVisible: false,
                ),
                onDaySelected: _onDaySelected,
                onRangeSelected: _onRangeSelected,
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
            Expanded(
              child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: defaultHorPadding,right: defaultHorPadding, top: defaultVerPadding*2, bottom: defaultVerPadding),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                  ),
                  child: value.isNotEmpty ? ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          //border: Border.all(),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: ListTile(
                          //splashColor: themeColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                          tileColor: Colors.white,
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    },
                  ) : Expanded(child: Container(margin: EdgeInsets.only(top: defaultVerPadding), child: Text('There is no appointment.', textAlign: TextAlign.center, style: GoogleFonts.comfortaa(color: Colors.white, fontSize: 15),))),
                );
              },
            ),
          ),
          ],
        ),
      //)
    );
  }
}