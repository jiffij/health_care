// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:simple_login/navigator.dart';
import 'package:simple_login/welcome.dart';
import 'doctor_info.dart';
import 'old/login_screen.dart';
// import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


FirebaseAuth auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();// binding with plugin with flutter engine 
  await Firebase.initializeApp();// make sure firebase is init
  runApp(const MyApp()); //MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: //const welcome(),
            const BottomNav(),
            //const DoctorDetailScreen(),
    );
  }
}
