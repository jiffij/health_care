import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_login/helper/loading_screen.dart';
import 'package:simple_login/yannie_version/pages/profile.dart';

import '../pages/yannie_home.dart';
import '../pages/yannie_calendar.dart';
import '../../chat/ChatSetup2D.dart';
import '../pages/profile_home.dart';
import 'nav_bar/custom_bottom_nav_bar_dash.dart';
import 'nav_bar/navbar_cubit.dart';

import '../../helper/firebase_helper.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  List<Widget> _pages = [];

  String fullname = '';
  String UID = "";

  @override
  void initState() {
    super.initState();
    start();
  }

  // Test
  void start() async {
    String uid = getUID();
    Map<String, dynamic>? user = await readFromServer('patient/$uid');
    fullname = user?['first name'] + ' ' + user?['last name'];
    UID = getUID();
    setState(() {});

    _pages = [
      const Home(),
      const CalendarPage(),
      ChatSetup2D(fullname),
      const ProfilePage(),
    ];
  }
  // Test

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
