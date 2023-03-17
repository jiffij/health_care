
import 'package:flutter/material.dart';
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
      title: 'Patient Questionnaire1 page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_Questionnaire1Page(),
    );
  }
}

class p_Questionnaire1Page extends StatefulWidget {
  const p_Questionnaire1Page({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  
  State<p_Questionnaire1Page> createState() => _p_Questionnaire1PageState();
}

class _p_Questionnaire1PageState extends State<p_Questionnaire1Page> {
  
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

      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading(width, height),
            home(width, height),           
          ],
        ),
    );
  }
  
  // All navigate direction calling method
  void navigator(int index) {
    switch (index) {
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
                margin: const EdgeInsets.only(top: 10),
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