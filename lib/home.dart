import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_login/color.dart';
import 'package:simple_login/custom_bottom_nav_bar_dash.dart';
import 'package:simple_login/title_with_more_btn.dart';
import 'package:simple_login/upcoming_appointment.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'navbar_helper/navbar_cubit.dart';
import 'navigator.dart';
import 'service.dart';
import 'header.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  @override
  Widget build(BuildContext context) {
    var cubit = NavbarCubit.get(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: 
                        SafeArea(
                          child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Header(size: size),
                              TitleWithMoreBtn(title: "Services", press: () {}, withBtn: false,),
                              const Services(),
                              TitleWithMoreBtn(title: "Upcoming Appointments", press: () {}, withBtn: true,),
                              //const Upcoming(),
                              Padding(padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.2), child: SizedBox(
                                height: 140,
                                //width: size.width*0.9,
                                child: PageView.builder(
                                  controller: _pageController,
                                  padEnds: true,
                                  itemCount: 3,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (_, __) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0),
                                      child: AppointmentCard(press: (){},),
                                    );
                                  },
                                ),
                              )),
                              Center(child: SmoothPageIndicator(
                                controller: _pageController,
                                count: 3,
                                effect: ExpandingDotsEffect(
                                  dotHeight: 6,
                                  dotWidth: 6,
                                  dotColor: themeColor.withOpacity(0.4),
                                  activeDotColor: themeColor),
                              )),
                            ],
                          ),
                        ))
    );
  }
}