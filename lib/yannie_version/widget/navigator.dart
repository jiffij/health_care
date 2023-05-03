import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:simple_login/yannie_version/pages/profile.dart';

import '../pages/yannie_home.dart';
import '../pages/yannie_calendar.dart';
import '../../chat/ChatSetup2.dart';
import '../pages/profile_home.dart';
import 'nav_bar/custom_bottom_nav_bar_dash.dart';
import 'nav_bar/navbar_cubit.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<Widget> _pages = [
    const Home(),
    const CalendarPage(),
    const ChatSetup2(),
    const ProfilePage(),
    //Container(),
  ];

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
              child: Center(
                child: _pages[cubit.currentIndex],
              ),
            ),
          );
        },
      ),
    );
  }
}
