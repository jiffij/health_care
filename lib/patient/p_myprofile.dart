import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Other files
import 'p_calendar.dart';
import 'p_homepage.dart';
import 'p_message.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient My Profile Page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      home: const p_MyProfilePage(),
    );
  }
}

class p_MyProfilePage extends StatefulWidget {
  const p_MyProfilePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override

  State<p_MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<p_MyProfilePage> {
  
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
    List<List> notificationslist = 
    [
      ['Upcoming appointment', 0xf06bb, 'MaterialIcons', 4],
      ['Medical Report', 0xe285, 'MaterialIcons', 5],
      ['Unread message', 0xe3e0, 'MaterialIcons', 6],
      ['Upcoming appointment', 0xf06bb, 'MaterialIcons', 7],
      ['Medical Report', 0xe285, 'MaterialIcons', 8],
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            heading(width, height),
            bloodandweight(width, height),
            notificationlist(width, height, notificationslist),
            home(width, height),           
          ],
        ),
    );
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

  Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Stack(
      children: [
        Container(
          width: globalwidth,
          height: globalheight*0.35,
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        Container(
          width: globalwidth,
          height: globalheight*0.25,
          color: const Color.fromARGB(255, 28, 107, 164),
          child: Container(
            margin: const EdgeInsets.only(top: 10, left: 12),
            child: Align(
              alignment: Alignment.topLeft ,
              child: Row(
                children: [
                  SizedBox(
                    height: globalheight*0.1,
                    child: const FittedBox (
                      fit: BoxFit.scaleDown,        
                      child: Text('My Profile', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 255, 255),)),
                    ),
                  ),
                  const Spacer(),
                  FittedBox(
                  fit: BoxFit.scaleDown,
                    child: SizedBox(
                      height: globalheight*0.1,
                      width: globalheight*0.1,
                      child: const FittedBox (
                        fit: BoxFit.scaleDown,
                        child: Icon(Icons.settings),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: globalwidth*0.05,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Row(
            children: [
              SizedBox(
                height: globalheight*0.2,
                width: globalwidth*0.05,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  height: globalheight*0.2,
                  width: globalwidth*0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 220, 237, 249),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container (
                              margin: const EdgeInsets.only(top: 10, left: 10),
                              child: const FittedBox (
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text('Heart Rate', style: TextStyle(fontSize: 20)),
                              ),
                            ),
                            Container (
                              margin: const EdgeInsets.only(left: 10, bottom: 10),
                              child: const FittedBox (
                                alignment: Alignment.centerLeft,
                                fit: BoxFit.scaleDown,
                                child: Text('xx', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        FittedBox (
                          fit: BoxFit.scaleDown,
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 5),
                            child:  const Icon(Icons.favorite, color: Color.fromARGB(255, 28, 107, 164), size: 100, 
                              shadows: [
                                BoxShadow(
                                  color: Color.fromARGB(200, 28, 107, 164),
                                  blurRadius: 1,
                                  offset: Offset(1, 1), 
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),    
                  ),
                ),
              ),
              SizedBox(
                height: globalheight*0.2,
                width: globalwidth*0.05,
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget bloodandweight(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: globalheight*0.2,
            width: globalwidth*0.42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 245, 225, 233),
            ),         
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FittedBox (
                        fit: BoxFit.scaleDown,
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child:  const Icon(Icons.water_drop, color: Color.fromARGB(255, 157, 76, 108)),
                        ),
                      ),
                      Container (
                        margin: const EdgeInsets.only(left: 5),
                        child: const FittedBox (
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text('Type', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),     
                  Container (
                    margin: const EdgeInsets.only(left: 10),
                    child: const FittedBox (
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Text('Blood Group', style: TextStyle(fontSize: 10),),
                    ),
                  ),
                ],
              ),    
            ),
          ),
          SizedBox(
            height: globalheight*0.2,
            width: globalwidth*0.06,
          ),
          Container(
            height: globalheight*0.2,
            width: globalwidth*0.42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 250, 240, 219),
            ),         
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        FittedBox (
                          fit: BoxFit.scaleDown,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child:  const Icon(Icons.accessibility_new, color: Color.fromARGB(255, 224, 159, 31)),
                          ),
                        ),
                        Container (
                          margin: const EdgeInsets.only(left: 5),
                          child: const FittedBox (
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text('xx kg', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),     
                    Container (
                      margin: const EdgeInsets.only(left: 10),
                      child: const FittedBox (
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text('Weight', style: TextStyle(fontSize: 10),),
                      ),
                    ),
                  ],
                ),    
              ),
          ),
        ],
      ),
    ),
  );

  Widget notificationlist(double globalwidth, double globalheight, list) => DefaultTextStyle.merge(
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
                child: Text('Notification', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: globalheight*0.3,
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
              return notification(index, globalwidth, globalheight, list[index]);
            },
          ),
        ),
      ],
    ),
  );

  Widget notification(int index, double globalwidth, double globalheight, List list) => Align(
    alignment: Alignment.center,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        height: globalheight*0.15,
        width: globalwidth*0.85,
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
                    child:  Icon(IconData(list[1], fontFamily: list[2]), color: const Color.fromARGB(255, 28, 107, 164)),
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,     
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Todo: The text need to divide automatically into multiple line when overflow
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('${list[3]} ${list[0]}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Tap to view your ${list[0]}', style: const TextStyle(fontSize: 8)),
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
                    Icon(Icons.person,color: Color.fromARGB(255, 28, 107, 164)),
                    Text('My Profile', style: TextStyle(color: Color.fromARGB(255, 28, 107, 164))),
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

