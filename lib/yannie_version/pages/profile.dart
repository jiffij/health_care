import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:simple_login/yannie_version/color.dart';
import 'package:simple_login/yannie_version/pages/yannie_welcome.dart';

import '../../main.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              if(checkSignedin()) auth.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(
                                                              builder: (context) => const welcome2()));
            }, 
            child: Text("Sign Out")),
        ),
      ),
    );
  }

}