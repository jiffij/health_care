import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'p_calendar.dart';
import 'p_homepage.dart';
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
      title: 'Doctor List page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_DoctorDetailPage(),
    );
  }
}

class p_DoctorDetailPage extends StatefulWidget {
  const p_DoctorDetailPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override

  State<p_DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<p_DoctorDetailPage> {
  
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
            detaillist(width, height),
            booknow(width, height),
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

  Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Stack(
    children: [
      Container(
        width: globalwidth,
        height: globalheight*0.31,
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
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
                margin: const EdgeInsets.only(left: 15, top: 20),
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
              Text('Doctor Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ), 
          ],
        ),
      ),
      Positioned(
        bottom: 0,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 15, top: 10),
            height: globalheight*0.12,
            width: globalwidth*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 220, 237, 249),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 0, 0, 0),
                  blurRadius: 0.5,
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: globalheight*0.1,
                  height: globalheight*0.1,
                  decoration : BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage('https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),    
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container (
                      margin: const EdgeInsets.only(left: 10),
                      child: const FittedBox (
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text('Doctor Name', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container (
                      margin: const EdgeInsets.only(left: 10),
                      child: const FittedBox (
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text('Doctor Title', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);

Widget detaillist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Column(
    children: [
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: globalheight*0.12,
            width: globalheight*0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 232, 235, 237),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.scaleDown,        
                child: Column(
                  children: const [
                    Text('Patient', style: TextStyle(fontSize: 12)),
                    Text('Number', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: globalheight*0.12,
            width: globalheight*0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 232, 235, 237),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.scaleDown,        
                child: Column(
                  children: const [
                    Text('Exp.', style: TextStyle(fontSize: 12)),
                    Text('Year', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ),
          ),Container(
            height: globalheight*0.12,
            width: globalheight*0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 232, 235, 237),
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: const [
                            Icon(Icons.star, color: Color.fromARGB(255, 0, 0, 0), size: 16,),
                            Icon(Icons.star, color: Color.fromARGB(255, 245, 245, 9), size: 15,),
                          ],
                        ), 
                        const Text('Rating', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    const Text('rate/5.0', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      Align(
        alignment: Alignment.centerLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 12, top: 12, bottom: 5),
            height: globalheight*0.05,
            width: globalwidth,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('About', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      Align(alignment: Alignment.centerLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 12, bottom: 12),
            width: globalwidth,
            height: globalheight*0.15,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Doctor Details:\nDoctor Details 1\nDoctor Details 2\nDoctor Details 3\nDoctor Details 4\nDoctor Details 5\nDoctor Details 6', style: TextStyle(fontSize: 10)),
                  Text('This Doctor Details is a very long information. It is a paragrath that may used multiple lines.', style: TextStyle(fontSize: 10)),
                  Text('Doctor Details 7', style: TextStyle(fontSize: 10)),
                  Text('Doctor Details 8', style: TextStyle(fontSize: 10)),
                  Text('Doctor Details 9', style: TextStyle(fontSize: 10)),
                  Text('Doctor Details 10', style: TextStyle(fontSize: 10)),
                ],
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
            height: globalheight*0.1,
            width: globalwidth*0.7,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 255, 255),
              boxShadow: const [
                BoxShadow(color: Color.fromARGB(255, 215, 222, 234), spreadRadius: 1),
              ],
            ),
            child: Row(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    margin: const EdgeInsets.only(left: 5, right: 10),
                    height: globalheight*0.07,
                    width: globalheight*0.07,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 220, 237, 249),
                    ),
                    child: FittedBox (
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        child:  const Icon(Icons.access_time_filled, color: Color.fromARGB(255, 28, 107, 164)),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,     
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      FittedBox(
                        child: Text('Daily Availability', style: TextStyle(fontSize: 10)),
                      ),
                      FittedBox(
                        child: Text('9 a.m. - 11 p.m.', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                    height: globalheight*0.03,
                    width: globalheight*0.03,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                      child: Icon(Icons.arrow_forward_ios, color: Color.fromARGB(255, 28, 107, 164)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);

Widget booknow(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Align(
    alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        height: globalheight*0.08,
        width: globalwidth*0.7,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 28, 107, 164),
          boxShadow: const [
            BoxShadow(color: Color.fromARGB(100, 28, 107, 164), spreadRadius: 2),
          ],
        ),
        child: const Text('Book Now', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
      ),
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
                    Text('Calendar'),
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