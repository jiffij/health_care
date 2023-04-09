import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Other files
import 'p_calendar.dart';
import 'p_homepage.dart';
import 'p_message.dart';
import 'p_myprofile.dart';

import '../helper/firebase_helper.dart';
import 'p_doctor_details.dart';


class p_DoctorListPage extends StatefulWidget {
  const p_DoctorListPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

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
            suggestdoctorlist(width, height),
            filtereddoctorlist(width, height),
            home(width, height),           
          ],
        ),
    );
  }

  final TextEditingController _doctorNameController = TextEditingController(text: "");
  bool nameError = false;
  List<List> doctorlist = [];
  List<List> doctorlistsort = [];

  @override
  void initState() {
    super.initState();
    start();
  }

  double getRating() {
    double temp = 0;

    return temp;
  }

  void start() async {
    List<String> doctorListId = await getColId('doctor');
    print(doctorListId);
    for (var id in doctorListId)
    {
      Map<String, dynamic>? data = await readFromServer('doctor/$id');
      var firstname = data?['first name'];
      var lastname = data?['last name'];
      var fullname = '$firstname $lastname';
      var uid = data?['profilePic'];
      var profilePic = await loadStorageUrl(uid);
      var title = data?['title'];
      var fRating = calRating(data?['rating']);
      print(data);
      setState(() {
        doctorlist.insert(0, [fullname, uid, profilePic, title, fRating]);
        //doctorlistsort.insert(0, [fullname, uid, profilePic, title, fRating]);
      });
      doctorlistsort = ratingSort();
    }
    print(doctorlist);
    print(doctorlistsort);
  }

  // All navigate direction calling method
  void navigator(int index, String doctor_uid) {
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
      case 5:
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => p_DoctorDetailPage(doctor_uid)),
        );
        break;
      default:
    }
    setState(() {});
  }

  List<List> ratingSort() {
    int comparisonIndex = 4;
    List<List<dynamic>> templist = doctorlist..sort((x, y) => 
    (x[comparisonIndex] as dynamic).compareTo((y[comparisonIndex] as dynamic)));
    return templist;
  }

  List<List> doctorSort(String input) {
    List<List> temp = [];
    for (var doctor in doctorlist)
    {
      var data = '${doctor[0]} ${doctor[3]}';
      if ((data).toLowerCase().trim().contains(input.toLowerCase().trim()))
      {
        temp.insert(0, doctor);
      }
    }
    return temp;
  }
  
  Widget heading(double globalwidth, double globalheight) => DefaultTextStyle.merge(
    child: Container(
      width: globalwidth,
      height: globalheight*0.25,
      color: const Color.fromARGB(255, 28, 107, 164),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => navigator(0,''),
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
            Text('Doctor List', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                height: globalheight*0.066,
                width: globalwidth*0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: TextField(
                  controller: _doctorNameController,
                  decoration: InputDecoration(
                    filled: nameError,
                    fillColor: Colors.red,
                    hintText: 'Search the doctor\'s name here...',
                    suffixIcon: GestureDetector(
                      onTap: () => {
                        doctorlistsort = doctorSort(_doctorNameController.text),
                        print(doctorlistsort),
                        setState(() {}),
                      },
                      child: const Icon(Icons.search),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
    ),
    ),
  );

  Widget suggestdoctorlist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
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
                child: Text('Suggested Doctors', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
            itemCount : doctorlist.length,
            separatorBuilder:  (context, index) {
              return const SizedBox(width: 15);
            },
            itemBuilder: (context, index) {
              return suggestdoctor(index, globalheight);
            },
          ),
        ),
      ],
    ),
  );

  Widget suggestdoctor(int index, double globalheight) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: () => navigator(5, doctorlist[index][1]),
        child: Container(
          height: globalheight*0.12,
          width: globalheight*0.12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(50, 224, 159, 31),
            image: DecorationImage(
              image: NetworkImage(doctorlist[index][2]),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
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
      ),
    ],
  );

  Widget filtereddoctorlist(double globalwidth, double globalheight) => DefaultTextStyle.merge(
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
                child: Text('Filtered Doctors (Default: Rating)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
            itemCount : doctorlistsort.length,
            separatorBuilder:  (context, index) {
              return const SizedBox(height: 15);
            },
            itemBuilder: (context, index) {
              return filtereddoctor(index, globalwidth, globalheight);
            },
          ),
        ),
      ],
    ),
  );

  Widget filtereddoctor(int index, double globalwidth, double globalheight) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        height: globalheight*0.15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: GestureDetector(
          onTap: () => navigator(5, doctorlistsort[index][1]),
          child: Row(
            children: [
              Container(
                width: globalheight*0.15,
                height: globalheight*0.15,
                margin: const EdgeInsets.only(right: 10),
                decoration : BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: NetworkImage(doctorlistsort[index][2]),
                    fit: BoxFit.cover,
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
                      Text('Doctor name: ${doctorlistsort[index][0]}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Doctor title: ${doctorlistsort[index][3]}', style: const TextStyle(fontSize: 14)),
                      Text('Rating: ${doctorlistsort[index][4].toString()}/5.0', style: const TextStyle(fontSize: 14)),
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
                onTap: () => navigator(1,''),
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
                onTap: () => navigator(2,''),
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
                onTap: () => navigator(3,''),
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
                onTap: () => navigator(4,''),
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

