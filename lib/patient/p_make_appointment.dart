import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Other files
import 'p_homepage.dart';
import 'p_calendar.dart';
import 'p_message.dart';
import 'p_myprofile.dart';

import '../helper/firebase_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Make Appointment page',
      theme: ThemeData(
          // This is the theme of the application.
          ),
      home: const p_MakeAppointmentPage('Default'),
    );
  }
}

class p_MakeAppointmentPage extends StatefulWidget {
  final String doctor_uid;

  const p_MakeAppointmentPage(this.doctor_uid, {super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<p_MakeAppointmentPage> createState() =>
      _MakeAppointmentPageState(doctor_uid);
}

class _MakeAppointmentPageState extends State<p_MakeAppointmentPage> {
  String doctor_uid;
  _MakeAppointmentPageState(this.doctor_uid);

  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String selected_timeslot = '';

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading(width, height),
          calendar(width, height),
          guide(width, height),
          //timeslotlist(width, height, timeslotslist, _focusedDay),
          home(width, height),
        ],
      ),
    );
  }
  
  String fullname = '';
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
    Map<String, dynamic>? data = await readFromServer('doctor/$doctor_uid');
    var firstname = data?['first name'];
    var lastname = data?['last name'];
    fullname = '$firstname $lastname';
    setState(() {
      print(data);
    });
  }

  // All navigate direction calling method
  void navigator(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop(context);
        break;
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const p_HomePage()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const p_CalendarPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const p_MessagePage()),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const p_MyProfilePage()),
        );
        break;
      default:
    }
    setState(() {});
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
            onPressed: () => navigator(1),
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
    List<String> existdatelist = await getColId('doctor/$doctor_uid/appointment');
    print(existdatelist);
    Map<String, dynamic>? existtimemap;
    // Get current exist datelist if available
    if (existdatelist.isNotEmpty) {
      for (var existdate in existdatelist) {
        if (existdate == dateToServer(_selectedDay!)) {
          print(existdate);
          existtimemap = await readFromServer('doctor/$doctor_uid/appointment/$existdate');
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
    var time = selected_timeslot;
    writeToServer('patient/$uid/appointment/$date', {
      time: {
        'doctorID': doctor_uid,
        'description': '',
      }
    });
    writeToServer('doctor/$doctor_uid/appointment/$date', {
      time: {
        'patientID': uid,
        'description': '',
      }
    });
    successful_message();
  }

  Widget heading(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Stack(
          children: [
            Container(
              width: globalwidth,
              height: globalheight * 0.25,
              color: const Color.fromARGB(255, 28, 107, 164),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => navigator(0),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 20),
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
                    margin: const EdgeInsets.only(top: 10),
                    child: Align(
                      alignment: Alignment.center,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Make Appointment',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Doctor: $fullname',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

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
          const Divider(),
          Container(
            height: globalheight * 0.04,
            margin: const EdgeInsets.only(bottom: 5),
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
                        child: Icon(Icons.circle,
                            color: Color.fromARGB(255, 28, 107, 164)),
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' : Available',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
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
                            color: Color.fromARGB(255, 123, 141, 158)),
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' : Full',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
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
                            color: Color.fromARGB(255, 36, 242, 31)),
                      ),
                    ),
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(' : Today',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
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
                    borderRadius: BorderRadius.circular(10),
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

  Widget home(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 3),
          width: globalwidth,
          height: globalheight * 0.07,
          color: const Color.fromARGB(255, 217, 217, 217),
          child: DefaultTextStyle(
            style: const TextStyle(color: Color.fromARGB(255, 123, 141, 158)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () => navigator(1),
                      child: Column(
                        children: const [
                          Icon(Icons.home,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          Text('Home'),
                        ],
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () => navigator(2),
                      child: Column(
                        children: const [
                          Icon(Icons.calendar_month,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          Text('Calendar',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 123, 141, 158))),
                        ],
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () => navigator(3),
                      child: Column(
                        children: const [
                          Icon(Icons.message,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          Text('Message'),
                        ],
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: GestureDetector(
                      onTap: () => navigator(4),
                      child: Column(
                        children: const [
                          Icon(Icons.person,
                              color: Color.fromARGB(255, 123, 141, 158)),
                          Text('My Profile'),
                        ],
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      );
}
