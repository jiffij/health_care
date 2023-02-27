
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// Other files
import 'p_homepage.dart';
import 'p_calendar.dart';
import 'p_message.dart';
import 'p_myprofile.dart';

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
      home: const p_MakeAppointmentPage(),
    );
  }
}

class p_MakeAppointmentPage extends StatefulWidget {
  const p_MakeAppointmentPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  
  State<p_MakeAppointmentPage> createState() => _MakeAppointmentPageState();
}

class _MakeAppointmentPageState extends State<p_MakeAppointmentPage> {

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

    // Todo: Decide hard code access data one by one
    List<List> timeslotslist = 
    [
      ['00:00', false, '00:20', false, '00:40', false],
      ['01:00', true, '01:20', false, '01:40', true],
      ['02:00', true, '02:20', true, '02:40', true],
      ['03:00', true, '03:20', true, '03:40', true],
      ['04:00', false, '04:20', false, '04:40', false],
      ['05:00', false, '05:20', false, '05:40', false],
      ['06:00', true, '06:20', true, '06:40', true],
      ['07:00', true, '07:20', true, '07:40', true],
      ['08:00', true, '08:20', true, '08:40', true],
      ['09:00', true, '09:20', true, '09:40', true],
      ['10:00', true, '10:20', true, '10:40', true],
      ['11:00', true, '11:20', true, '11:40', true],
      ['12:00', true, '12:20', true, '12:40', true],
      ['13:00', true, '13:20', false, '13:40', false],
      ['14:00', false, '14:20', false, '14:40', true],
      ['15:00', true, '15:20', true, '15:40', true],
      ['16:00', true, '16:20', false, '16:40', false],
      ['17:00', true, '17:20', true, '17:40', true],
      ['18:00', true, '18:20', true, '18:40', true],
      ['19:00', true, '19:20', true, '19:40', true],
      ['20:00', true, '20:20', true, '20:40', true],
      ['21:00', true, '21:20', true, '21:40', true],
      ['22:00', true, '22:20', true, '22:40', true],
      ['23:00', true, '23:20', true, '23:40', true],
    ];

    return Scaffold(

      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading(width, height),
            //calendar(width, height),
            guide(width, height),
            timeslotlist(width, height, timeslotslist),  
            home(width, height),           
          ],
        ),
    );
  }
  
  // All navigate direction calling method
  void navigator(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pop(context);
        break;
      case 1:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_HomePage()),
        );
        break;
      case 2:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_CalendarPage()),
        );
        break;
      case 3:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_MessagePage()),
        );
        break;
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_MyProfilePage()),
        );
        break;
      default:
    }
    setState(() {});
  }

  void change_timeslot(String newTimeslot) {
    selected_timeslot = newTimeslot;
    setState(() {});
  }

  void warning_message() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('This timeslot is unavailable!'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Exit'),
              child: const Text('Exit'),
            ),
          ],
        ),
    );
  }
  

  Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Stack(
      children: [
        Container(
          width: globalwidth,
          height: globalheight*0.25,
          color: const Color.fromARGB(255, 28, 107, 164),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  height: globalheight*0.06,
                  width: globalheight*0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: FittedBox (
                    fit: BoxFit.scaleDown,
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      child: const Icon(Icons.arrow_back_rounded),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Align(
                  alignment: Alignment.center,
                  child: FittedBox (
                    fit: BoxFit.scaleDown,        
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Make Appointment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('Doctor: Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

  Widget calendar(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime(2020),
                lastDay: DateTime(2050),
                focusedDay: DateTime.now(),
                // Todo: Calendar interatives
              ),
            ],
          ),
        ),
      ),
    ),
  );

  String getDate(DateTime date) {
    var formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);
    return formattedDate.toString();
  }

  Widget guide(double globalwidth, double globalheight) => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    mainAxisSize: MainAxisSize.min,
    children: [
      const Divider(),
      Container(
        height: globalheight*0.04,
        margin: const EdgeInsets.only(bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                SizedBox(
                  width: globalheight*0.02,
                  height: globalheight*0.02,
                  child: const FittedBox (
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.circle, color: Color.fromARGB(255, 28, 107, 164)),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text (' : Available', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: globalheight*0.02,
                  height: globalheight*0.02,
                  child: const FittedBox (
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.circle, color: Color.fromARGB(255, 123, 141 , 158)),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text (' : Full', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: globalheight*0.02,
                  height: globalheight*0.02,
                  child: const FittedBox (
                    fit: BoxFit.scaleDown,
                    child: Icon(Icons.circle, color: Color.fromARGB(255, 36, 242 , 31)),
                  ),
                ),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text (' : Today', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );

  Widget timeslotlist(double globalwidth, double globalheight, list) => DefaultTextStyle.merge(
    child: Container(
      padding: const EdgeInsets.all(12),
      width: globalwidth,
      height: globalheight*0.5,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        color: Color.fromARGB(255, 28, 107, 164),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: globalheight*0.05,
            width: globalwidth *0.4,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                children: [
                  const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Date',
                      style: TextStyle(fontSize: 50, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: globalheight*0.1,
                    width: globalwidth*0.2,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: globalheight*0.1,
                        width: globalwidth,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          boxShadow: const [
                            BoxShadow(color: Color.fromARGB(100, 28, 107, 164), spreadRadius: 2),
                          ],
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
                height: globalheight*0.2,
                width: globalwidth*0.8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 28, 107, 164),
                    boxShadow: [
                      BoxShadow(color: Color.fromARGB(0, 0, 0, 0), spreadRadius: 2),
                    ],
                  ),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    // The number of itemCount depends on the number of appointment
                    // 5 is the number of appointment for testing only
                    itemCount : 24,
                    separatorBuilder:  (context, index) {
                      return SizedBox(height: globalheight*0.04);
                    },
                    itemBuilder: (context, index) {
                      return timeslot(index, globalwidth, globalheight, list[index]);
                    },
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                height: globalheight*0.08,
                width: globalwidth*0.7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  boxShadow: const [
                    BoxShadow(color: Color.fromARGB(150, 255, 255, 255), spreadRadius: 2),
                  ],
                ),
                child: const Text('Make Appointment', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 28, 107, 164), fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget timeslot(int index, double globalwidth, double globalheight, List list) => Align(
    //alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => list[1] == true ? change_timeslot(list[0]) : warning_message(),
            child: Container(
              height: globalheight*0.08,
              width: globalwidth*0.22,
              padding: EdgeInsets.all(globalheight*0.02),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: list[1] == true ? list[0] == selected_timeslot ? const Color.fromARGB(255, 224, 159, 31) : const Color.fromARGB(255, 28, 107, 164) : const Color.fromARGB(255, 123, 141, 158),
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(255, 190, 202, 218), spreadRadius: 2),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${list[0]}', style: const TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ),
          SizedBox(
            width: globalwidth*0.06,
          ),
          GestureDetector(
            onTap: () => list[3] == true ? change_timeslot(list[2]) : warning_message(),
            child: Container(
              height: globalheight*0.08,
              width: globalwidth*0.22,
              padding: EdgeInsets.all(globalheight*0.02),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: list[3] == true ? list[2] == selected_timeslot ? const Color.fromARGB(255, 224, 159, 31) : const Color.fromARGB(255, 28, 107, 164) : const Color.fromARGB(255, 123, 141, 158),
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(255, 190, 202, 218), spreadRadius: 2),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${list[2]}', style: const TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ),
          SizedBox(
            width: globalwidth*0.06,
          ),
          GestureDetector(
            onTap: () => list[5] == true ? change_timeslot(list[4]) : warning_message(),
            child: Container(
              height: globalheight*0.08,
              width: globalwidth*0.22,
              padding: EdgeInsets.all(globalheight*0.02),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: list[5] == true ? list[4] == selected_timeslot ? const Color.fromARGB(255, 224, 159, 31) : const Color.fromARGB(255, 28, 107, 164) : const Color.fromARGB(255, 123, 141, 158),
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(255, 190, 202, 218), spreadRadius: 2),
                ],
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${list[4]}', style: const TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255))),
              ),
            ),
          ),
        ],
      ),  
    ),
  );

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
                    Icon(Icons.calendar_month,color: Color.fromARGB(255, 123, 141, 158)),
                    Text('Calendar', style: TextStyle(color: Color.fromARGB(255, 123, 141, 158))),
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