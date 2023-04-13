import 'package:flutter/material.dart';
import 'package:simple_login/doctor_search.dart';
import 'package:simple_login/index.dart';
import 'package:simple_login/search.dart';

import 'color.dart';

class Services extends StatelessWidget {
  const Services({
    Key? key,
  }) : super(key: key);

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
            ),Container(margin: EdgeInsets.only(top: 15),child: Text('Booking', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.heart_broken,size: 35, color: themeColor), tap: (){}),Container(margin: EdgeInsets.only(top: 15),child: Text('Health', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.medical_information,size: 35, color: themeColor), tap: (){}),Container(margin: EdgeInsets.only(top: 15),child: Text('Record', style: label,))]),
              Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [ServiceButton(icon: Icon(Icons.settings,size: 35, color: themeColor), tap: (){}),Container(margin: EdgeInsets.only(top: 15),child: Text('Settings', style: label,))]),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: defaultVerPadding,
                ),
                child: InkWell(
                onTap: () {},
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

