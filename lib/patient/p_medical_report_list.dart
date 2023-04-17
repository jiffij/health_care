import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Chat - Integration
import '../main.dart';
// Chat - Integration

// Other files
import 'p_calendar.dart';
import 'p_homepage.dart';
import 'p_message.dart';
import 'p_myprofile.dart';

class p_MedicalReportListPage extends StatefulWidget {
  const p_MedicalReportListPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<p_MedicalReportListPage> createState() => _MedicalReportListPageState();
}

class _MedicalReportListPageState extends State<p_MedicalReportListPage> {
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
          //currentdoctorlist(width, height),
          medicalreportlist(width, height),
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
      // Chat - Integration
      case 3:
        Navigator.of(context).pushNamed(routeChatHome);
        /* backup
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const p_MessagePage()),
        );
        */
        break;
      // Chat - Integration
      case 4:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const p_MyProfilePage()),
        );
        break;
      default:
    }
    setState(() {});
  }

  Widget heading(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Container(
          width: globalwidth,
          height: globalheight * 0.25,
          color: const Color.fromARGB(255, 28, 107, 164),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => navigator(0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Container(
                    margin: const EdgeInsets.only(left: 15, top: 20),
                    height: globalheight * 0.06,
                    width: globalheight * 0.06,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: FittedBox(
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text('My Medical Report',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  height: globalheight * 0.07,
                  width: globalwidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Row(
                    children: [
                      const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Icon(Icons.search),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        child: const FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text('Search By Report Number...',
                              style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const Spacer(),
                      const FittedBox(
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

  Widget medicalreportlist(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  height: globalheight * 0.05,
                  width: globalwidth,
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Medical Report History',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: globalheight * 0.60,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.all(12),
                // The number of itemCount depends on the number of appointment
                // 5 is the number of appointment for testing only
                itemCount: 5,
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return medicalreport(index, globalwidth, globalheight);
                },
              ),
            ),
          ],
        ),
      );

  Widget medicalreport(int index, double globalwidth, double globalheight) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: globalheight * 0.15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(80, 224, 159, 31),
              boxShadow: const [
                BoxShadow(
                    color: Color.fromARGB(50, 224, 159, 31), spreadRadius: 3),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: globalheight * 0.15,
                  height: globalheight * 0.15,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 220, 237, 249),
                  ),
                  child: SizedBox(
                    width: globalwidth * 0.15,
                    height: globalheight * 0.15,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text('Click here', style: TextStyle(fontSize: 30)),
                          Text('to download', style: TextStyle(fontSize: 30)),
                          Text('the report!', style: TextStyle(fontSize: 30)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: globalwidth * 0.55,
                  height: globalheight * 0.15,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Medical Report Number: 12345678 $index',
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Text('Issued by: Doctor\'s Name',
                            style: TextStyle(fontSize: 30)),
                        const Text('Issued on: Date',
                            style: TextStyle(fontSize: 30)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
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
                              color: Color.fromARGB(255, 123, 141, 158)),
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
