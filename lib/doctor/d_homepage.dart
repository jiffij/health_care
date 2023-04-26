import 'package:flutter/material.dart';
// import 'package:flutter_user_interface_model/p_doctor_list.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:swipe_widget/swipe_widget.dart';

// Other files
import '../news/model/article_model.dart';
import '../news/news.dart';
import '../news/pages/articles_details_page.dart';
import '../news/services/api_service.dart';
import '../news/web_view.dart';
import '../video_call/join_call_waiting.dart';
import '../video_call/start_call.dart';
import 'd_calendar.dart';
import 'd_myprofile.dart';
import 'd_myprofile.dart';
import 'cancer_prediction.dart';
import '../register.dart';
import 'd_diagnosis_form.dart';
import 'd_medical_report_list.dart';
import 'd_medical_allergy.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:simple_login/patient/p_diagnostic_survey.dart';
import 'package:simple_login/patient/p_medical_allergy.dart';
import 'package:swipe_widget/swipe_widget.dart';

class d_HomePage extends StatefulWidget {
  const d_HomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<d_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<d_HomePage> {
  ApiService client = ApiService();

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

    return !startDone
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                heading(width, height, context),
                services(width, height),
                meetadoctor(width, height),
                upcomingappointmentlist(width, height),
                home(width, height),
              ],
            ),
          );
  }

  var now = DateTime.now();
  String fullname = '';
  int numOfAppointment = 0;
  List<List> appointments = [];
  late List<Article> articles;
  bool startDone = false;
  // int index = 0;
  List<String> newsUrl = [
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c'
  ];

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? data = await readFromServer('doctor/$uid');
    fullname = data?['first name'] + ' ' + data?['last name'];
    List<String> existdatelist = await getColId('doctor/$uid/appointment');
    Map<String, dynamic>? existtimemap;
    if (existdatelist.isNotEmpty) {
      var date = dateToServer(now);
      for (var existdate in existdatelist) {
// <<<<<<< HEAD
        // existtimemap = await readFromServer('patient/$uid/appointment/$existdate');
        // List timeList = existtimemap!.keys.toList();
        // List<List> dailyAppointmentList = [];
        // for (var time in timeList) {
        //   var id = existtimemap[time]['doctorID'];
        //   //print(id);
        //   Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
        //   var dFirstname = doctor?['first name'];
        //   var dLastname = doctor?['last name'];
        //   var dFullname = '$dFirstname $dLastname';
        //   dailyAppointmentList.insert(0, [existdate, time, dFullname]);
        // }
        // //print(dailyAppointmentList);
        // dailyAppointmentList = dailyAppointmentList.reversed.toList();
        // print(dailyAppointmentList);
        // for (var list in dailyAppointmentList) {
        //   appointments.insert(0, list);
// =======
        // Check if the appointment has passed alreadly or not
        if (int.parse(existdate) >= int.parse(date)) {
          existtimemap =
              await readFromServer('doctor/$uid/appointment/$existdate');
          List timeList = existtimemap!.keys.toList();
          // print('timeList');
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
            // Case 00:00
            if (temp.length == 1) {
              temp = '00:0${temp[0]}';
            }
            // Case 00:x0
            else if (temp.length == 2) {
              temp = '00:$temp';
            }
            // Case 0x:xx
            else if (temp.length == 3) {
              temp = '0${temp[0]}:${temp[1]}${temp[2]}';
            } else {
              temp = '${temp[0]}${temp[1]}:${temp[2]}${temp[3]}';
            }
            timeList.add(temp);
          }
          List<List> dailyAppointmentList = [];
          for (var time in timeList) {
            var id = existtimemap[time]['patientID'];
            //print(id);
            Map<String, dynamic>? doctor = await readFromServer('patient/$id');
            var pFirstname = doctor?['first name'];
            var pLastname = doctor?['last name'];
            var pFullname = '$pFirstname $pLastname';
            dailyAppointmentList.insert(0, [existdate, time, pFullname, id]);
          }
          //print(dailyAppointmentList);
          dailyAppointmentList = dailyAppointmentList.reversed.toList();
          print(dailyAppointmentList);
          for (var list in dailyAppointmentList) {
            appointments.insert(0, list);
          }
// >>>>>>> leon_dev1
        }
      }
      appointments = appointments.reversed.toList();
    }
    setState(() {});
    articles = await client.getArticle();

    setState(() {
      for (int i = 0; i < 3; i++) {
        if (articles[i].urlToImage != "") {
          newsUrl[i] = articles[i].urlToImage;
        }
      }
      startDone = true;
    });
  }

  // All navigate direction calling method
  void navigator(int index) {
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const d_HomePage()),
        );
        break;
      case 2:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const d_CalendarPage()),
        );
        break;
      case 3:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => DiagnosticSurvey(
                  'DnLy1aqV1WRg66qqmz9HGg8zotF2', '20230426', '00:00')),
        );
        break;
      case 4:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const d_MyProfilePage()),
        );
        break;
      case 6:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NewsPage()),
        );
        break;
      case 7:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const d_MedicalAllergyPage()),
        );
        break;
      case 8:
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => const d_MedicalReportListPage()),
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

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
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

  Widget heading(
          double globalwidth, double globalheight, BuildContext context) =>
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
            // newsList(context),
          ],
        ),
      );

  // Widget newsList(
  //         BuildContext context, double globalwidth, double globalheight) =>
  //     ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: 3,
  //       itemBuilder: (context, index) {
  //         //let's check if we got a response or not
  //         if (newsUrl.isNotEmpty) {
  //           //Now let's make a list of articles

  //           return InkWell(
  //             onTap: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (context) => ArticlePage(
  //                             article: articles[index],
  //                           )));
  //             },
  //             child: Container(
  //               height: globalheight * 0.8,
  //               width: globalwidth * 0.15,
  //               decoration: BoxDecoration(
  //                 //let's add the height

  //                 image: DecorationImage(
  //                     image: NetworkImage(articles[index].urlToImage),
  //                     fit: BoxFit.cover),
  //                 borderRadius: BorderRadius.circular(12.0),
  //               ),
  //             ),
  //           );
  //         }
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       },
  //     );

  // TODO: Change to another news
  Widget news(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        // child: SwipeWidget(
        //   angle: 0,

        child: Container(
          width: globalwidth * 0.8,
          height: globalheight * 0.15,
          // padding: const EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(10),
          //   color: const Color.fromARGB(255, 220, 237, 249),
          //   boxShadow: const [
          //     BoxShadow(
          //       color: Color.fromARGB(255, 0, 0, 0),
          //       blurRadius: 0.5,
          //       offset: Offset(0.5, 0.5),
          //     ),
          //   ],
          // ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: globalwidth * 0.8,
                height: globalheight * 0.15,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyWebView(url: articles[index].url)),
                      );
                    },
                    child: Image.network(
                      newsUrl[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        // Change to another page
        //   onSwipeRight: () => news(globalwidth, globalheight),
        // ),
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
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                    child: Image.asset('assets/doctor.png',
                        fit: BoxFit.fill,
                        color: const Color.fromARGB(255, 224, 159, 31)),
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
                  child: Image.asset('assets/message.png',
                      fit: BoxFit.fill,
                      color: const Color.fromARGB(255, 247, 56, 89)),
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
                    child: Image.asset('assets/virus.png',
                        fit: BoxFit.fill,
                        color: const Color.fromARGB(255, 157, 76, 108)),
                  ),
                ),
              ),
            ]),
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
                itemCount: appointments.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 20);
                },
                itemBuilder: (context, index) {
                  return upcomingappointment(index, globalwidth, globalheight);
                },
              ),
            ),
          ],
        ),
      );

  Widget upcomingappointment(
          int index, double globalwidth, double globalheight) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: globalheight * 0.13,
            width: globalwidth * 0.7,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(80, 224, 159, 31),
            ),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => JoinCallWaiting(appointments[index][3], appointments[index][1])),
              ),
              child: Row(
                children: [
                  Container(
                    width: globalheight * 0.15,
                    height: globalheight * 0.13,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 220, 237, 249),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${appointments[index][0]}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                          Text(
                            'Time: ${appointments[index][1]}',
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          Text('Patient: ${appointments[index][2]}',
                              style: const TextStyle(fontSize: 20)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
