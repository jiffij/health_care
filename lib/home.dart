import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_login/color.dart';
import 'package:simple_login/custom_bottom_nav_bar_dash.dart';
import 'package:simple_login/title_with_more_btn.dart';
import 'package:simple_login/upcoming_appointment.dart';

import 'navbar_helper/navbar_cubit.dart';
import 'navigator.dart';
import 'service.dart';
import 'header.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var cubit = NavbarCubit.get(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: 
                        SafeArea(child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Header(size: size),
                              TitleWithMoreBtn(title: "Services", press: () {}, withBtn: false,),
                              const Services(),
                              TitleWithMoreBtn(
                                title: "Upcoming Appointments",
                                press: () {
                                  // Navigate to another page and update the navbar
                                  cubit.changeBottomNavBar(1);
                                },
                                withBtn: true,
                              ),
                              const Upcoming(),
                            ],
                          ),
                        ))
    );
  }
}