import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/yannie_version/pages/yannie_welcome.dart';
import "package:simple_login/main.dart";
import '../../helper/firebase_helper.dart';
import '../color.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.name,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultVerPadding),
      //margin: EdgeInsets.only(bottom: 0),
      height: MediaQuery.of(context).size.height * 0.13,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: defaultHorPadding,
              right: defaultHorPadding,
              bottom: defaultVerPadding,
            ),
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                      color: goodColor.withOpacity(0.1),
                    ),
                  ],
            ),
            child: Row( 
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.02), child: Text(DateFormat('dd MMMM, yyyy, EEEE').format(DateTime.now()), style: datetime,)),
                    Text("Hi, "+ name + " !", style: greeting,),
                  ],
                ),
                Spacer(),
                IconButton(onPressed: () async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const welcome2()));
                  final GoogleSignIn googleSignIn = GoogleSignIn();
                  if (checkSignedin()) await auth.signOut();
                  if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();
                }, icon: Icon(Icons.logout),
                  iconSize: 40,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}