import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:simple_login/yannie_version/color.dart';

import '../../helper/alert.dart';

class Invite extends StatefulWidget {
  String DocUid;
  String dateTime;

  Invite(this.DocUid, this.dateTime);

  @override
  _InviteState createState() => _InviteState();
}

class _InviteState extends State<Invite> {

  final TextEditingController _uidController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
        child: Scaffold(
          backgroundColor: bgColor,
          appBar: AppBar(
            //title: Text('Search For Doctor'),
            elevation: 0,
            toolbarHeight: 80,
            backgroundColor: Colors.transparent,
            titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: lighttheme, fontSize: 19, fontWeight: FontWeight.w500)),
            centerTitle: true,
            title: Text('Invititation'),
            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
            leading: Padding(
                padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
                child: ElevatedButton(
                    style: ButtonStyle(
                      //minimumSize: MaterialStatePropertyAll(Size(60, 60)),
                        elevation: MaterialStatePropertyAll(1),
                        shadowColor: MaterialStatePropertyAll(themeColor),
                        side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                          color: themeColor,
                        )),
                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Icon(Icons.arrow_back, size: 23,color: themeColor,)
                )),
            leadingWidth: 95,
          ),
          body: SafeArea(//child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20)
              ),
              //width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height*0.4,
              padding: EdgeInsets.all(25.0),
              margin: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                      "Enter a User Id to invite him/her to join you meeting:",
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w300, fontSize: 16))
                  ),
                  SizedBox(height: 30.0),
                  Padding(
                    padding: const EdgeInsets.only( bottom: 25),
                    child: TextFormField(
                      controller: _uidController,
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black)),
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: themeColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: themeColor),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: themeColor,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "User ID",
                        hintText: '',
                        labelStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: themeColor)),
                        hintStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Color.fromARGB(255, 148, 148, 148))),
                      ),
                    ),
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                    onPressed: () {
                      _invite();
                      Navigator.of(context).pop();
                    },
                    child: Text("Invite",
                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17))
                    ),
                    style: ButtonStyle(
                      padding: MaterialStatePropertyAll(const EdgeInsets.symmetric(vertical: 18)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0), // Set rounded corner radius
                        ),
                      ),
                      minimumSize: MaterialStateProperty.all<Size>(Size.fromHeight(50)), // Set minimum size
                      backgroundColor: MaterialStateProperty.all<Color>(lighttheme), // Set background color
                    ),
                  ),
                ],
              ),
            ),
            //)
          ),
        ));
  }

  void _invite() async {
    var inviteuid = _uidController.text;
    var date = widget.dateTime;
    var doctor = widget.DocUid;
    var myuid = getUID();
    var time = date.substring(8,10) + ":" + date.substring(10,12);
    await writeToServer("patient/$inviteuid/invitation/$date", {
      "token": doctor+myuid,
      "doctorID": doctor,
      "time": date,
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Reset Email Sent"),
          content: Text(
              "An email with instructions to reset your password has been sent to your email address. Please check your inbox and follow the instructions to reset your password."),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}