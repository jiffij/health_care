import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../helper/firebase_helper.dart';
import '../../news/model/article_model.dart';
import '../../news/services/api_service.dart';
import '../color.dart';
import '../widget/header.dart';
import '../widget/nav_bar/navbar_cubit.dart';
import '../widget/service.dart';
import '../widget/title_with_more_btn.dart';
import '../widget/upcoming_appointment.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final PageController _pageController = PageController(viewportFraction: 0.9);
  var now = DateTime.now();
  String fullname = '';
  int numOfAppointment = 0;
  List<List> appointments = [];
  late List<Article> articles;
  ApiService client = ApiService();
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

  @override
  Widget build(BuildContext context) {
    var cubit = NavbarCubit.get(context);
    Size size = MediaQuery.of(context).size;
    return !startDone? LoadingScreen(): Scaffold(
      backgroundColor: bgColor,
      body: 
                        SafeArea(
                          child: Column(
                            children: [
                              Header(name: fullname),
                              Flexible(child: SingleChildScrollView(
                                //physics: AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    TitleWithMoreBtn(title: "Services", press: () {}, withBtn: false,),
                                    Services(),
                                    TitleWithMoreBtn(title: "Upcoming Appointments", press: () {}, withBtn: false,),
                                    Padding(padding: EdgeInsets.symmetric(vertical: defaultVerPadding),
                                    child: SizedBox(
                                      height: size.height*0.18,
                                      //width: size.width*0.9,
                                      child: appointments.isEmpty? 
                                      Center(
                                        child: Container(
                                          width: size.width*0.85,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child: Center(child: Text("No appointment today.", style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15),)),
                                        ),
                                      )
                                    : PageView.builder(
                                        controller: _pageController,
                                        padEnds: true,
                                        itemCount: appointments.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                            child: AppointmentCard(appointment: appointments[index]),
                                          );
                                        },
                                      ),
                                    )),
                                     Padding(
                                      padding: EdgeInsets.only(bottom: defaultVerPadding,),
                                      child: appointments.isEmpty? null : Center(child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: appointments.length,
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 6,
                                        dotWidth: 6,
                                        dotColor: themeColor.withOpacity(0.4),
                                        activeDotColor: themeColor),
                                    ))),
                                  ],
                                ),
                              ))
                            ]
                          )
                        )
    );
  }


  

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? user = await readFromServer('patient/$uid');
    fullname = user?['first name'] + ' ' + user?['last name'];
    List<String> existdatelist = await getColId('patient/$uid/appointment');
    Map<String, dynamic>? existtimemap;
    if (existdatelist.isNotEmpty) {
      var date = dateToServer(now);
      for (var existdate in existdatelist) {
// <<<<<<< HEAD
        existtimemap =
            await readFromServer('patient/$uid/appointment/$existdate');
        List timeList = existtimemap!.keys.toList();
        List<List> dailyAppointmentList = [];
        for (var time in timeList) {
          var id = existtimemap[time]['doctorID'];
          //print(id);
          Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
          var dFirstname = doctor?['first name'];
          var dLastname = doctor?['last name'];
          var dFullname = '$dFirstname $dLastname';
          dailyAppointmentList.insert(0, [existdate, time, dFullname]);
        }
        //print(dailyAppointmentList);
        dailyAppointmentList = dailyAppointmentList.reversed.toList();
        print(dailyAppointmentList);
        for (var list in dailyAppointmentList) {
          appointments.insert(0, list);
// =======
//         // Check if the appointment has passed alreadly or not
//         if (int.parse(existdate) >= int.parse(date)) {
//           existtimemap = await readFromServer('patient/$uid/appointment/$existdate');
//           List timeList = existtimemap!.keys.toList();
//           // print('timeList');
//           List timeListint = [];
//           for (var time in timeList) {
//             var temp = time[0] + time[1] + time[3] + time[4];
//             temp = int.parse(temp);
//             // Todo Check if the funciton is work
//             timeListint.add(temp);
//           }
//           timeListint.sort();
//           timeList.clear();
//           for (var time in timeListint) {
//             String temp = time.toString();
//             if (temp.length == 3) {
//               temp = '0${temp[0]}:${temp[1]}${temp[2]}';
//             }
//             else {
//               temp = '${temp[0]}${temp[1]}:${temp[2]}${temp[3]}';
//             }
//             timeList.add(temp);
//           }
//           List<List> dailyAppointmentList = [];
//           for (var time in timeList) {
//             var id = existtimemap[time]['doctorID'];
//             //print(id);
//             Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
//             var dFirstname = doctor?['first name'];
//             var dLastname = doctor?['last name'];
//             var dFullname = '$dFirstname $dLastname';
//             dailyAppointmentList.insert(0, [existdate, time, dFullname]);
//           }
//           //print(dailyAppointmentList);
//           dailyAppointmentList = dailyAppointmentList.reversed.toList();
//           print(dailyAppointmentList);
//           for (var list in dailyAppointmentList) {
//             appointments.insert(0, list);
//           }
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

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
    return formattedDate.toString();
  }
}