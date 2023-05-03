import 'dart:async';

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
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int picIndex = 0;
  late Timer _timer;

  final PageController _pageController = PageController(viewportFraction: 0.9);
  var now = DateTime.now();
  String fullname = '';
  int numOfAppointment = 0;
  List<List> appointments = [];
  List<List> upcomappointments = [];
  List<List> serverData = [];
  List<Article>? articles;
  ApiService client = ApiService();
  bool startDone = false;
  // int index = 0;
  List<String> newsUrl = [
    // 'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    // 'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c',
    // 'https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c'
  ];
  // List<String> photos = [
  //   "https://thumbs.dreamstime.com/b/medicine-doctor-holding-red-heart-shape-hand-medical-icon-network-connection-modern-virtual-screen-interface-service-mind-99681240.jpg",
  //   "https://www.state.gov/wp-content/uploads/2019/04/shutterstock_669184549.jpg",
  //   "https://srinivasgroup.com/img/MedicalDepartment/_home/slider/slide02.jpg",
  //   "https://bogota.gov.co/sites/default/files/styles/1050px/public/2020-05/coronavirus-mitos-verdades-rumores-oms.jpg",
  //   "https://cdn.who.int/media/images/default-source/publications/brochure/exercise-f2-30032016-ph-73-batch2.tmb-479v.jpg?sfvrsn=a22afefa_12%20479w"
  // ];

  @override
  void initState() {
    _timer = Timer.periodic(new Duration(seconds: 4), (_) {
      setState(() {
        picIndex = (picIndex + 1);
      });
    });
    super.initState();
    start();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                                    Services(serverData: appointments, article: articles![picIndex%articles!.length]),
                                    TitleWithMoreBtn(title: "Upcoming Appointments", press: () {}, withBtn: false,),
                                    Padding(padding: EdgeInsets.symmetric(vertical: defaultVerPadding),
                                    child: SizedBox(
                                      height: size.height*0.18,
                                      //width: size.width*0.9,
                                      child: upcomappointments.isEmpty? 
                                      Center(
                                        child: Container(
                                          width: size.width*0.85,
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.7),
                                            borderRadius: BorderRadius.all(Radius.circular(30))
                                          ),
                                          child: Center(child: Text("No upcoming appointment.", style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 15),)),
                                        ),
                                      )
                                    : PageView.builder(
                                        controller: _pageController,
                                        padEnds: true,
                                        itemCount: upcomappointments.length,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 0),
                                            child: UpcomingAppointmentCard(appointment: upcomappointments[index]),
                                          );
                                        },
                                      ),
                                    )),
                                     Padding(
                                      padding: EdgeInsets.only(bottom: defaultVerPadding,),
                                      child: upcomappointments.isEmpty? null : Center(child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: upcomappointments.length,
                                      effect: ExpandingDotsEffect(
                                        dotHeight: 6,
                                        dotWidth: 6,
                                        dotColor: themeColor.withOpacity(0.4),
                                        activeDotColor: themeColor),
                                    ))),
                                  ],
                                ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          bottom: defaultVerPadding,
                        ),
                        child: appointments.isEmpty
                            ? null
                            : Center(
                                child: SmoothPageIndicator(
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
              ));
            //])));
  }

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? user = await readFromServer('patient/$uid');
    fullname = user?['first name'] + ' ' + user?['last name'];

    List<String> appointmentDays = await getColId('patient/$uid/appointment');
    Map<String, dynamic>? anAppointment;
    if (appointmentDays.isNotEmpty) {
      var date = dateToServer(now);
      for (var day in appointmentDays) {
        anAppointment = await readFromServer('patient/$uid/appointment/$day');
        List timeList = anAppointment!.keys.toList();
        List<List> dailyAppointmentList = [];
        for (var time in timeList) {
          var id = anAppointment[time]['doctorID'];
          var status = anAppointment[time]['status'];
          Map<String, dynamic>? doctor = await readFromServer('doctor/$id');
          var dFirstname = doctor?['first name'];
          var dLastname = doctor?['last name'];
          var dFullname = '$dFirstname $dLastname';
          dailyAppointmentList.insert(0, [day, time, dFullname, id, status]);
          if(status == 'confirmed') {
            bool isCompleted= DateTime.now().add(Duration(hours: 1)).isAfter(toDateTime(day, time));
            if (isCompleted) {
              writeToServer('patient/$uid/appointment/$day', {
                time: {
                  'doctorID': id,
                  'description': '',
                  'status': 'completed'
                }
              });
              writeToServer('doctor/$id/appointment/$day', {
                time: {
                  'patientID': uid,
                  'description': '',
                  'status': 'completed'
                }
              });
            }
            else upcomappointments.insert(0, [day, time, dFullname, id, status]);
          }
        }
        //print(dailyAppointmentList);
        dailyAppointmentList = dailyAppointmentList.reversed.toList();
        print(dailyAppointmentList);
        for (var list in dailyAppointmentList) {
          appointments.insert(0, list);
        }
      }
      appointments = appointments.reversed.toList();
    }
    //setState(() {startDone = true;});
    articles = await client.getArticle();
    setState(() {
      startDone = true;
    });

    setState(() {
      for (int i = 0; i < 3; i++) {
        if (articles![i].urlToImage != "") {
          newsUrl[i] = articles![i].urlToImage;
        } else
          newsUrl[i] =
              "https://srinivasgroup.com/img/MedicalDepartment/_home/slider/slide02.jpg";
      }
      startDone = true;
    });
  }

  String dateToServer(DateTime date) {
    var formattedDate = DateFormat('yMMdd').format(date);
    return formattedDate.toString();
  }
  DateTime toDateTime(String date, String time) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(4, 6));
    int day = int.parse(date.substring(6));
    int hour = int.parse(time.substring(0, 2));
    int min = int.parse(time.substring(3, 5));
    return DateTime(year, month, day, hour, min);
  }
}
