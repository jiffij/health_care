import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/patient/p_medical_allergy.dart';
import 'package:swipe_widget/swipe_widget.dart';

// Other files
import 'p_calendar.dart';
import 'p_message.dart';
import 'p_myprofile.dart';
import 'p_doctor_list.dart';

import 'p_medical_report_list.dart';
import 'package:simple_login/helper/firebase_helper.dart';

class p_HomePage extends StatefulWidget {
  const p_HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<p_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<p_HomePage> {

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
          services(width, height),
          meetadoctor(width, height),
          upcomingappointmentlist(width, height),
          home(width, height),
        ],
      ),
    );
  }

  String fullname = '';

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
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_DoctorListPage()),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_HomePage()),
        );
      break;
      case 7:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_MedicalAllergyPage()),
        );
        break;
      case 8:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_MedicalReportListPage()),
        );
        break;
    default:
    }
    setState(() {});
  }  

  String getCurrentDate() {
    var date = DateTime.now();
    var formattedDate = DateFormat('EEEE, d MMM yyyy').format(date);
    return formattedDate.toString();
  }

  String greetingMessage() {
    var timeNow = DateTime.now().hour;
    if (timeNow <= 11.59) {
      return 'Good Morning!';
    } else if (timeNow > 12 && timeNow <= 16) {
      return 'Good Afternoon!';
    } else if (timeNow > 16 && timeNow < 20) {
      return 'Good Evening!';
    } else {
      return 'Good Night!';
    }
  }

  Widget heading(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Stack(
          children: [
            Container(
              width: globalwidth,
              height: globalheight * 0.25,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, top: 5),
              height: globalheight * 0.07,
              width: globalwidth,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(getCurrentDate(),
                          style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold)),
                        Text(greetingMessage(),
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                        Text(fullname,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      ]),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Row(
                children: [
                  SizedBox(
                    width: globalwidth * 0.1,
                    height: globalheight * 0.15,
                  ),
                  news(globalwidth, globalheight),
                  SizedBox(
                    width: globalwidth * 0.1,
                    height: globalheight * 0.15,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // Todo: Change to another news
  Widget news(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: SwipeWidget(
          angle: 0,
          child: Container(
            width: globalwidth * 0.8,
            height: globalheight * 0.15,
            padding: const EdgeInsets.all(10),
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
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text('This is the place for news'),
            ),
          ),
          // Change to another page
          onSwipeRight: () => news(globalwidth, globalheight),
        ),
      );

  Widget services(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 5),
                  height: globalheight * 0.03,
                  width: globalwidth,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Services:',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    onTap: () => navigator(7),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: globalheight * 0.08,
                      width: globalheight * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 220, 237, 249),
                      ),
                      // Todo: Change the icon
                      child: Image.asset(
                        'assets/pill.png',
                        fit: BoxFit.fill,
                        color: const Color.fromARGB(255, 28, 107, 164),
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    onTap: () => navigator(8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      height: globalheight * 0.08,
                      width: globalheight * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 250, 240, 219),
                      ),
                      child: Image.asset(
                        'assets/doctor.png',
                        fit: BoxFit.fill,
                        color: const Color.fromARGB(255, 224, 159, 31)
                      ),
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    height: globalheight * 0.08,
                    width: globalheight * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(38, 247, 56, 89),
                    ),
                    child: Image.asset(
                      'assets/message.png',
                      fit: BoxFit.fill,
                      color: const Color.fromARGB(255, 247, 56, 89)
                    ),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: GestureDetector(
                    onTap: () => navigator(6),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      height: globalheight * 0.08,
                      width: globalheight * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 242, 227, 233),
                      ),
                      child: Image.asset(
                        'assets/virus.png',
                        fit: BoxFit.fill,
                        color: const Color.fromARGB(255, 157, 76, 108)),
                    ),
                  ),
                ),
              ]
            ),
          ],
        ),
      );

  Widget meetadoctor(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: GestureDetector(
          onTap: () => navigator(5),
          child: Container(
            padding: const EdgeInsets.all(10),
            height: globalheight * 0.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 220, 237, 249),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: globalwidth * 0.4,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      children: const [
                        Text(
                          'Meet a doctor \nOnline now!',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Text('Just a few simple steps',
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: globalwidth * 0.4,
                  height: globalheight * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://cdn.imgbin.com/16/14/21/imgbin-physician-hospital-medicine-doctor-dentist-doctor-MvjeZ7XWhJkkxsq5WJJQFWNcK.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget upcomingappointmentlist(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  height: globalheight * 0.03,
                  width: globalwidth,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Upcoming Appointments:',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: globalheight * 0.2,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(12),
                // The number of itemCount depends on the number of appointment
                // 5 is the number of appointment for testing only
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 20);
                },
                itemBuilder: (context, index) {
                  return upcomingappointment(index, globalheight);
                },
              ),
            ),
          ],
        ),
      );

  Widget upcomingappointment(int index, double globalheight) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: globalheight * 0.13,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(80, 224, 159, 31),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(50, 224, 159, 31), spreadRadius: 3),
              ],
            ),
            child: Text('This is the appointment $index'),
          )
        ],
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
                              color: Color.fromARGB(255, 28, 107, 164)),
                          Text('Home',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 28, 107, 164))),
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