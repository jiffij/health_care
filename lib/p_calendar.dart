import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_CalendarPage(title: 'Flutter Patient Calendar Page'),
    );
  }
}

class p_CalendarPage extends StatefulWidget {
  const p_CalendarPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  
  State<p_CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<p_CalendarPage> {
  
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
    DateTime selectedDay = DateTime.now();
    return Scaffold(

      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading(width, height),
            calendar(width, height),
            upcomingappointmentlist(width, height, selectedDay),
            home(width, height),           
          ],
        ),
    );
  }
}

Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Stack(
    children: [
      Container(
        width: globalwidth,
        height: globalheight*0.15,
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
            const Align(
              alignment: Alignment.center,  
              child: FittedBox (
              fit: BoxFit.scaleDown,        
              child: 
              Text('Calendar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ), 
          ],
        ),
      ),
      // Positioned(
      //   top: globalheight*0.12,
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         //width: globalwidth,
      //         //height: globalheight*0.58,
      //         child:  calendar(globalwidth, globalheight),
      //       ),
      //   ],
      //   ),
      // ),
    ],
  ),
);

Widget calendar(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Expanded(
    child: SizedBox(
      //width: globalwidth,
      //height: globalheight*0.45,
      child: TableCalendar(
        shouldFillViewport: true,
        firstDay: DateTime(2020),
        lastDay: DateTime(2050),
        focusedDay: DateTime.now(),
        // Todo: Calendar interatives
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
            height: globalheight*0.03,
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
          itemCount : 5,
          separatorBuilder:  (context, index) {
            return const SizedBox(height: 5);
          },
          itemBuilder: (context, index) {
            return upcomingappointment(index, globalheight);
          },
        ),
      ),
    ],
  ),
);

// Todo: Access database and update the upcommingappointment list
Widget upcomingappointment(int index, double globalheight) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      height: globalheight*0.1,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(80, 224, 159, 31),
      ),
      child: Row(
        children: [
          SizedBox(
            width: globalheight*0.05,
            height: globalheight*0.05,
            child: const FittedBox (
              fit: BoxFit.scaleDown,
              child: Icon(Icons.call_rounded),
            ),
          ),
          Text ('This is the appointment $index'),
        ],
      ),
    ),
    const Divider(),
  ],
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
            child: Column(
              children: const [
                Icon(Icons.home,color: Color.fromARGB(255, 123, 141, 158)),
                Text('Home'),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: const [
                Icon(Icons.calendar_month,color: Color.fromARGB(255, 28, 107, 164)),
                Text('Calendar', style: TextStyle(color: Color.fromARGB(255, 28, 107, 164))),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: const [
                Icon(Icons.message,color: Color.fromARGB(255, 123, 141, 158)),
                Text('Message'),
              ],
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              children: const [
                Icon(Icons.person,color: Color.fromARGB(255, 123, 141, 158)),
                Text('My Profile'),
              ],
            ),
          ),
        ]
      ),
    ),
  ),
);