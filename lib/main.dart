// import 'dart:html';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';

void main() {
  runApp(const MyApp()); //MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginScreen(),
    );
  }
}
