import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_login/color.dart';
import 'package:simple_login/patient/p_calendar.dart';
import 'package:simple_login/patient/p_homepage.dart';
import 'package:simple_login/patient/p_myprofile.dart';
import 'package:simple_login/new_home.dart';
import 'navbar_cubit.dart';
import 'custom_bottom_nav_bar_dash.dart';

class BottomNav extends StatefulWidget {
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavbarCubit(),
      child: BlocConsumer<NavbarCubit, NavbarState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = NavbarCubit.get(context);

          return Scaffold(
            bottomNavigationBar: CustomBottomNavBarDash(
              onChange: (index) {
                cubit.changeBottomNavBar(index);
              },
              defaultSelectedIndex: 0,
              radius: 50,
              showLabel: true,
              textList: const [
                'Home',
                'Calendar',
                'Messenger',
                'Profile',
              ],
              iconList: const [
                Icons.home_outlined,
                Icons.calendar_month,
                Icons.chat,
                Icons.person,
              ],
            ),
            extendBody: true,
            body: Container(
              color: themeColor.withOpacity(0.25),
              child: Center(
                child: //Text('Hello from Item ${cubit.currentIndex}'),
                        (cubit.currentIndex == 0)? p_HomePage() : 
                        (cubit.currentIndex == 1)? Test() :
                        (cubit.currentIndex == 2)? Container() : p_MyProfilePage(),
              ),
            ),
          );
        },
      ),
    );
  }
}