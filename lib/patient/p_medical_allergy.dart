import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Other files
import 'p_calendar.dart';
import 'p_homepage.dart';
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
      title: 'Medical Allergy page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_MedicalAllergyPage(),
    );
  }
}

class p_MedicalAllergyPage extends StatefulWidget {
  const p_MedicalAllergyPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override

  State<p_MedicalAllergyPage> createState() => _MedicalAllergyPageState();
}

class _MedicalAllergyPageState extends State<p_MedicalAllergyPage> {
  
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
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                detaillist(width, height),
                modifybutton(width, height),
                mdshow ? modifypage(width, height)
                    : Container(),
              ],
            ),
            heading(width, height),
            home(width, height),           
          ],
        ),
    );
  }

  String fullname = '';
  bool mdshow = false;
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _contactController = TextEditingController(text: "");
  final TextEditingController _relationController = TextEditingController(text: "");
  final TextEditingController _allergyController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? data = await readFromServer('patient/$uid');
    setState(() {
      fullname = data?['first name'] + ' ' + data?['last name'];
      print(fullname);
    });
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
            GestureDetector(
              onTap: () => navigator(0),
              child: FittedBox(
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
            ),
            const Align(
              alignment: Alignment.center,  
              child: FittedBox (
              fit: BoxFit.scaleDown,        
              child: 
              Text('Personal Emergency Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
                  ),
                  child: const FittedBox(
                    fit: BoxFit.cover,
                    child: Icon(Icons.person,color: Color.fromARGB(255, 123, 141, 158)),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container (
                      margin: const EdgeInsets.only(left: 10),
                      child: FittedBox (
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text('User Full Name: $fullname', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // Container (
                    //   margin: const EdgeInsets.only(left: 10),
                    //   child: const FittedBox (
                    //     alignment: Alignment.centerLeft,
                    //     fit: BoxFit.scaleDown,
                    //     child: Text('Doctor Title', style: TextStyle(fontSize: 12)),
                    //   ),
                    // ),
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
              child: Text('Emergency Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
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
                  Text('Patient Details:\nPatient Details 1\nPatient Details 2\nPatient Details 3\nPatient Details 4\nPatient Details 5\nPatient Details 6', style: TextStyle(fontSize: 16)),
                  Text('This Patient Details is a very long information. It is a paragrath that may used multiple lines.', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 7', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 8', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 9', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 10', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
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
              child: Text('Allergy Details', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerLeft,
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
                  TextField(),
                  Text('Patient Details:\nPatient Details 1\nPatient Details 2\nPatient Details 3\nPatient Details 4\nPatient Details 5\nPatient Details 6', style: TextStyle(fontSize: 16)),
                  Text('This Patient Details is a very long information. It is a paragrath that may used multiple lines.', style: TextStyle(fontSize: 16)),
                  Text('Allergy Details 7', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 8', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 9', style: TextStyle(fontSize: 16)),
                  Text('Patient Details 10', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  ),
);

Widget modifybutton(double globalwidth, double globalheight) => DefaultTextStyle.merge(
  child: GestureDetector(
    onTap: () => setState(() {mdshow = !mdshow;}),
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
          child: const Text('~~Click here to modify the details~~', style: TextStyle(fontSize: 12, color: Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold)),
        ),
      ),
    ),
  ),
);

Widget modifypage(double globalwidth, double globalheight) =>DefaultTextStyle.merge(
  child: Container(
    height: globalheight*0.4,
    width: globalwidth,
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: _nameController,
                  // cursorColor: Colors.orange,
                  decoration: InputDecoration(
                    labelText: 'Emergency Contact Name:',
                    hintText: 'Emergency Contact Name',
                    // suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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