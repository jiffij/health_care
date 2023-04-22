
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Other files
import 'p_homepage.dart';
import 'p_message.dart';
import 'p_myprofile.dart';

import 'package:simple_login/helper/firebase_helper.dart';

// Details for calendar customization:
// https://blog.logrocket.com/build-custom-calendar-flutter/
// https://stackoverflow.com/questions/69818820/how-to-change-header-formatting-in-flutter-table-calendar-package

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Calendar page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_CalendarPage(),
    );
  }
}

class p_CalendarPage extends StatefulWidget {
  const p_CalendarPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  
  State<p_CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<p_CalendarPage> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  
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
            home(width, height),           
          ],
        ),
    );
  }
  
  String fullname = '';
  bool tlshow = false;
  int numOfAppointment = 0;
  List<List> appointmentslist = [];
  List<List> appointmentslistsort = [];

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? data = await readFromServer('patient/$uid');
    fullname = data?['first name'] + ' ' + data?['last name'];
    List<String> existdatelist = await getColId('patient/$uid/appointment');
    Map<String, dynamic>? existtimemap;
    if (existdatelist.isNotEmpty) {
      for (var existdate in existdatelist) {
        existtimemap = await readFromServer('patient/$uid/appointment/$existdate');
        List timeList = existtimemap!.keys.toList();
        print('timeList');
        List timeListint = [];
        for (var time in timeList) {
          var temp = time[0] + time[1] + time[3] + time[4];
          temp = int.parse(temp);
          // Todo Check if the funciton is work
          timeListint.add(temp);
        }
        timeListint.sort();
        timeList.clear();
        for (var time in timeListint) {
          String temp = time.toString();
          if (temp.length == 3) {
            temp = '0${temp[0]}:${temp[1]}${temp[2]}';
          }
          else {
            temp = '${temp[0]}${temp[1]}:${temp[2]}${temp[3]}';
          }
          timeList.add(temp);
        }
        List<List> dailyAppointmentList = [];
        for (var time in timeList) {
          var id = existtimemap[time]['doctorID'];
          //print(id);
          Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
          var dFirstname = doctor?['first name'];
          var dLastname = doctor?['last name'];
          var dFullname = '$dFirstname $dLastname';
          dailyAppointmentList.insert(0, [existdate, time, dFullname]);
        }
        print(dailyAppointmentList);
        dailyAppointmentList = dailyAppointmentList.reversed.toList();
        print(dailyAppointmentList);
        for (var list in dailyAppointmentList) {
          appointmentslist.insert(0, list);
        }
      }
      appointmentslist = appointmentslist.reversed.toList();
      print(appointmentslist);
    }
    setState(() {});
  }

  // All navigate direction calling method
  void navigator(int index) {
    switch (index) {
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

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
    return formattedDate.toString();
  }

  List<List> appointmentSort(String input) {
    List<List> temp = [];
    for (var appointment in appointmentslist)
    {
      var date = '${appointment[0]}';
      if ((date).toLowerCase().trim().contains(input.toLowerCase().trim()))
      {
        temp.insert(0, appointment);
      }
    }
    return temp;
  }

  Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Stack(
      children: [
        Container(
          width: globalwidth,
          height: globalheight*0.08,
          color: const Color.fromARGB(255, 28, 107, 164),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15),
                child: const Align(
                  alignment: Alignment.center,
                  child: FittedBox (
                  fit: BoxFit.scaleDown,        
                  child: 
                  Text('Calendar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        child: Column(
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
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay; // update `_focusedDay` here as well
                        appointmentslistsort = appointmentSort(dateToServer(_focusedDay));
                        appointmentslistsort = appointmentslistsort.reversed.toList();
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                  ),
                ],
              ),
            ),
            upcomingappointmentlist(globalwidth, globalheight, _focusedDay),
          ],
        ),
      ),
    ),
  );

  String getDate(DateTime date) {
    var formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);
    return formattedDate.toString();
  }

  Widget upcomingappointmentlist(double globalwidth, double globalheight, DateTime selectedDay) => DefaultTextStyle.merge(
    child: Column(
      children: [
        Align(alignment: Alignment.centerLeft,
          child: FittedBox(
              fit: BoxFit.scaleDown,
            child: Container(
              margin: const EdgeInsets.only(left: 12, bottom: 5),
              height: globalheight*0.025,
              width: globalwidth,
              child: FittedBox (
                alignment: Alignment.centerLeft,
                fit: BoxFit.scaleDown,
                child: Text(getDate(selectedDay), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            ),
          ),
        ),
        SizedBox(
          height: globalheight*0.15,
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.all(12),
            // The number of itemCount depends on the number of appointment
            // 5 is the number of appointment for testing only
            itemCount : appointmentslistsort.length,
            separatorBuilder:  (context, index) {
              return const SizedBox(height: 5);
            },
            itemBuilder: (context, index) {
              return upcomingappointment(index, globalwidth, globalheight);
            },
          ),
        ),
      ],
    ),
  );

  Widget upcomingappointment(int index, double globalwidth, double globalheight) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: globalheight*0.12,
        width: globalwidth*0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(80, 224, 159, 31),
        ),
        child: GestureDetector(
          //onTap: () => navigator(5, appointments[index][1]),
          child: Row(
            children: [
              Container(
                width: globalheight*0.2,
                height: globalheight*0.13,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10),
                decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 220, 237, 249),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: globalheight*0.05,
                          height: globalheight*0.05,
                          child: const FittedBox (
                            fit: BoxFit.scaleDown,
                            child: Icon(Icons.call_rounded),
                          ),
                        ),
                        SizedBox(
                          width: globalheight*0.12,
                          child: const FittedBox (
                            fit: BoxFit.scaleDown,
                            child: Text ('Click the Icon \nto join the call!', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ],
                    ),
                    const FittedBox (
                      fit: BoxFit.scaleDown,
                      child: Text ('You can only join the call on time', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: globalwidth * 0.3,
                height: globalheight * 0.15,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Time: ${appointmentslistsort[index][1]}', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),),
                      Text('Doctor: ${appointmentslistsort[index][2]}', style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      const Divider(),
    ],
  );

  // Todo: Access database and update the upcommingappointment list
  // Widget upcomingappointment(int index, double globalheight) => Column(
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     Container(
  //       height: globalheight*0.12,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: const Color.fromARGB(80, 224, 159, 31),
  //       ),
  //       child: Row(
  //         children: [
  //           SizedBox(
  //             width: globalheight*0.05,
  //             height: globalheight*0.05,
  //             child: const FittedBox (
  //               fit: BoxFit.scaleDown,
  //               child: Icon(Icons.call_rounded),
  //             ),
  //           ),
  //           Text ('This is the appointment $index'),
  //         ],
  //       ),
  //     ),
  //     const Divider(),
  //   ],
  // );

  Widget home(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      width: globalwidth,
      height: globalheight*0.07,
      color : const Color.fromARGB(255, 217, 217, 217),
      child : DefaultTextStyle(
        style : const TextStyle(color : Color.fromARGB(255, 123, 141, 158)),
        child : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [   
            FittedBox(
              fit: BoxFit.scaleDown,
              child: GestureDetector(
                onTap: () => navigator(1),
                child: Column(
                  children: const [
                    Icon(Icons.home,color: Color.fromARGB(255, 123, 141, 158)),
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
                    Icon(Icons.calendar_month,color: Color.fromARGB(255, 28, 107, 164)),
                    Text('Calendar', style: TextStyle(color: Color.fromARGB(255, 28, 107, 164))),
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
                    Icon(Icons.message,color: Color.fromARGB(255, 123, 141, 158)),
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
                    Icon(Icons.person,color: Color.fromARGB(255, 123, 141, 158)),
                    Text('My Profile'),
                  ],
                ),
              ),
            ),
          ]
        ),
      ),
    ),
  );
}