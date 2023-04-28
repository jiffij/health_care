import 'package:flutter/material.dart';
// import 'package:flutter_user_interface_model/p_doctor_list.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:swipe_widget/swipe_widget.dart';

// Other files
import '../news/model/article_model.dart';
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

  String fullname = '';
  late List<Article> articles;
  bool startDone = false;
  // int index = 0;
  List<String> newsUrl = [
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c'
  ];

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
    return !startDone? LoadingScreen() :
    Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          heading(width, height),
          services(width, height),
          upcomingappointmentlist(width, height),
          home(width, height),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    var uid = getUID();
    // var res = awaitreadFromServer('');
    start();
  }

  void start() async {
    // String uid = getUID();
    // Map<String, dynamic>? data = await readFromServer('patient/$uid');
    // setState(() {
    //   fullname = data?['first name'] + ' ' + data?['last name'];
    //   print(fullname);
    // });
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
  // Todo: Change the direction to dctor page after created
  void navigator(int index) {
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => StartCall("L6S9xfMD3wWnLFGpRaJWDH8ulmt2", "00:00")),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const d_CalendarPage()),
      );
    } else if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => DiagnosticForm(
                'John', '202304260000', 'L6S9xfMD3wWnLFGpRaJWDH8ulmt2')),
      );
    } else if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const d_MyProfilePage()),
      );
    } else if (index == 5) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const CancerPredict()),
      );
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
              height: globalheight * 0.27,
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
                        MaterialPageRoute(builder: (context) => MyWebView(url: articles[index].url)),
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
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: globalheight * 0.08,
                        width: globalheight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 220, 237, 249),
                        ),
                        // Todo: Change the icon
                        child: const Icon(Icons.home,
                            color: Color.fromARGB(255, 28, 107, 164)),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: globalheight * 0.08,
                        width: globalheight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 250, 240, 219),
                        ),
                        child: const Icon(Icons.medical_services_rounded,
                            color: Color.fromARGB(255, 224, 159, 31)),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        height: globalheight * 0.08,
                        width: globalheight * 0.08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(38, 247, 56, 89),
                        ),
                        child: const Icon(Icons.chat,
                            color: Color.fromARGB(255, 247, 56, 89)),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: GestureDetector(
                        onTap: () => navigator(5),
                        child: Container(
                          height: globalheight * 0.08,
                          width: globalheight * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 242, 227, 233),
                          ),
                          child: const Icon(Icons.coronavirus,
                              color: Color.fromARGB(255, 157, 76, 108)),
                        ),
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      );

  Widget upcomingappointmentlist(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
                    child: Text('Today\'s Appointments:',
                        style: TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: globalheight * 0.4,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text('Appointment\'s Time',
                style: TextStyle(
                    fontSize: 10, color: Color.fromARGB(255, 125, 150, 181))),
          ),
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 12),
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
