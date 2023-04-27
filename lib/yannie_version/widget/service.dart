import 'package:flutter/material.dart';
import 'package:simple_login/news/news.dart';
import 'package:simple_login/patient/p_doctor_list.dart';
import 'package:simple_login/yannie_version/pages/yannie_myBooking.dart';

import '../../patient/p_medical_report_list.dart';
import '../color.dart';
import '../pages/yannie_doctor_search.dart';

class Services extends StatelessWidget {
  const Services({
    Key? key,
    required this.serverData
  }) : super(key: key);

  final List serverData;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
          top: defaultVerPadding,
          bottom: defaultVerPadding,
        ),
      child: Column(
        children: <Widget> [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(
                icon: Icon(Icons.person_search,size: 35, color: themeColor,), 
                tap: (){Navigator.of(context).push(_createRoute(const DoctorSearch()));}
            ),Container(margin: EdgeInsets.only(top: 15),child: Text('Search', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.heart_broken,size: 35, color: themeColor), tap: (){}),Container(margin: EdgeInsets.only(top: 15),child: Text('Health', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.description,size: 35, color: themeColor), tap: (){
                Navigator.of(context).push(_createRoute(p_MedicalReportListPage()));
              }),Container(margin: EdgeInsets.only(top: 15),child: Text('Record', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.event_available,size: 35, color: themeColor), tap: (){
                Navigator.of(context).push(_createRoute(myBooking(serverData: serverData,)));
              }),Container(margin: EdgeInsets.only(top: 15),child: Text('Booking', style: label,))]),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: defaultVerPadding,
                ),
                child: InkWell(
                onTap: () {Navigator.of(context).push(_createRoute(NewsPage()));},
                borderRadius: BorderRadius.circular(30),
                splashFactory: InkRipple.splashFactory,
                splashColor: goodColor.withOpacity(0.1),
                child: Ink(
                  width: size.width * 0.87,
                  height: size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                    boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 10),
                              blurRadius: 20,
                              color: goodColor.withOpacity(0.13),
                            ),
                          ],
                  ),
                ),
              ))
            ],
          ),
      ]),

    );
  }
}

class ServiceButton extends StatelessWidget {

  const ServiceButton({
    Key? key,
    required Icon this.icon,
    required Function() this.tap
  }): super(key: key);

  final icon;
  final tap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width*0.015),
      child: InkWell(
          onTap: tap,
          splashFactory: InkRipple.splashFactory,
          borderRadius: BorderRadius.all(Radius.circular(30)),
          child: Ink(
            padding: EdgeInsets.all(10),
            height: size.width*0.2,
            width: size.width*0.2,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: themeColor), bottom: BorderSide(color: themeColor), right: BorderSide(color: themeColor), left: BorderSide(color: themeColor),),
              borderRadius: BorderRadius.all(Radius.circular(30)),
              color: Colors.white,
              boxShadow: defaultShadow,
            ),
            child: icon,
          ),
        ));
  }

}

Route _createRoute(Widget destinition) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinition,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

