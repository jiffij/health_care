import 'package:flutter/material.dart';
import 'p_homepage.dart';
import 'p_calendar.dart';
import 'p_doctor_list.dart';
import 'p_doctor_details.dart';
import 'p_myprofile.dart';

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
      //home: const p_CalendarPage(title: 'Flutter Patient Calendar Page'),
      //home: const p_DoctorListPage(title: 'Flutter Patient Doctor List Page'),
      //home: const p_DoctorDetailPage(title: 'Flutter Patient Doctor Detail Page'),
      home: const p_HomePage(title: 'Flutter Patient Home Page'),
      //home: const p_MyProfilePage(title: 'Flutter Patient My Profile Page'),
    );
  }
}