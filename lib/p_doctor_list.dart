import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
      home: const p_DoctorListPage(title: 'Flutter Patient Doctor List Page'),
    );
  }
}

class p_DoctorListPage extends StatefulWidget {
  const p_DoctorListPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override

  State<p_DoctorListPage> createState() => _DoctorListPageState();
}

class _DoctorListPageState extends State<p_DoctorListPage> {
  
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
            currentdoctorlist(width, height),
            highrateddoctorlist(width, height),
            home(width, height),           
          ],
        ),
    );
  }
}

Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Container(
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
        const Align(
          alignment: Alignment.center,  
          child: FittedBox (
          fit: BoxFit.scaleDown,        
          child: 
          Text('Doctor List', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 15, top: 10),
            height: globalheight*0.07,
            width: globalwidth*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Row(
              children: [
                const FittedBox (
                  fit: BoxFit.scaleDown,
                  child: Icon(Icons.search),
                ),
                Container (
                  margin: const EdgeInsets.only(left: 5),
                  child: const FittedBox (
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,        
                    child: Text('Search Doctor...', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const Spacer(),
                const FittedBox (
                  alignment: Alignment.centerRight,
                  fit: BoxFit.scaleDown,
                  child: Icon(Icons.manage_search),
                ),
              ],
            ),
          ),
        ),             
      ],
  ),
  ),
);

Widget currentdoctorlist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Column(
    children: [
      Align(alignment: Alignment.centerLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            height: globalheight*0.05,
            width: globalwidth,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('Current Available Doctors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      SizedBox(
        height: globalheight*0.2,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          // The number of itemCount depends on the number of appointment
          // 5 is the number of appointment for testing only
          itemCount : 5,
          separatorBuilder:  (context, index) {
            return const SizedBox(width: 15);
          },
          itemBuilder: (context, index) {
            return currentdoctor(index, globalheight);
          },
        ),
      ),
    ],
  ),
);

Widget currentdoctor(int index, double globalheight) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      height: globalheight*0.12,
      width: globalheight*0.12,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(50, 224, 159, 31),
      ),
      child: Stack(
        children: [
          Text ('Doctor Photo $index', style: const TextStyle(fontSize: 10)),
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              height: globalheight*0.02,
              width: globalheight*0.02,
              decoration: const BoxDecoration(
                color: Color.fromARGB(130, 0, 255, 0),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Color.fromARGB(255, 255, 255, 255), spreadRadius: 3),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  ],
);

Widget highrateddoctorlist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: Column(
    children: [
      Align(alignment: Alignment.centerLeft,
        child: FittedBox(
            fit: BoxFit.scaleDown,
          child: Container(
            margin: const EdgeInsets.only(left: 12),
            height: globalheight*0.05,
            width: globalwidth,
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text('High Rated Doctors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      SizedBox(
        height: globalheight*0.35,
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(12),
          // The number of itemCount depends on the number of appointment
          // 5 is the number of appointment for testing only
          itemCount : 5,
          separatorBuilder:  (context, index) {
            return const SizedBox(height: 15);
          },
          itemBuilder: (context, index) {
            return highrateddoctor(index, globalheight);
          },
        ),
      ),
    ],
  ),
);

Widget highrateddoctor(int index, double globalheight) => Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Container(
      height: globalheight*0.15,
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color.fromARGB(80, 224, 159, 31),
      boxShadow: const [
      BoxShadow(color: Color.fromARGB(50, 224, 159, 31), spreadRadius: 3),
      ],
      ),
      child: Row(
        children: [
          Container(
            width: globalheight*0.15,
            height: globalheight*0.15,
            decoration : BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: NetworkImage('https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
                fit: BoxFit.cover,
              ),
            ),    
          ),
          Text ('Doctor Details $index'),
        ],
      ),
    ),
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
                Icon(Icons.calendar_month,color: Color.fromARGB(255, 123, 141, 158)),
                Text('Calendar'),
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