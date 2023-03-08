import 'package:flutter/material.dart';
import 'package:simple_login/color.dart';
import 'package:simple_login/title_with_more_btn.dart';
import 'package:simple_login/upcoming_appointment.dart';

import 'service.dart';
import 'header.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      //appBar: AppBar(elevation: 0, backgroundColor: Colors.white),
      body: 
                        SafeArea(child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Header(size: size),
                              TitleWithMoreBtn(title: "Services", press: () {}, withBtn: false,),
                              Services(),
                              TitleWithMoreBtn(title: "Upcoming Appointments", press: () {}, withBtn: true,),
                              const Upcoming(),
                              //SizedBox(height: nav),
                            ],
                          ),
                        ))
    );
  }
}