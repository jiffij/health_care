import 'package:flutter/material.dart';

// Patient page:
import 'p_homepage.dart';

// Doctor page:
// import 'd_homepage.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main page',
      theme: ThemeData(
        // This is the theme of the application.
      ),
      //home: const p_CalendarPage(),
      //home: const p_DoctorListPage(),
      //home: const p_DoctorDetailPage(),
      home: const p_HomePage(),
      //home: const d_HomePage(),
      //home: const p_MyProfilePage(),
    );
  }
}