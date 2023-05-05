import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_login/helper/alert.dart';
import 'package:simple_login/helper/loading/loading_popup.dart';
import 'package:simple_login/yannie_version/pages/yannie_welcome.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../helper/firebase_helper.dart';
import '../../helper/message_page.dart';
import '../../main.dart';
import '../color.dart';

class SignUp2 extends StatefulWidget {
  const SignUp2({Key? key, required GoogleSignIn this.google})
      : super(key: key);

  final GoogleSignIn google;

  @override
  State<SignUp2> createState() => _SignUp2State();
}

class _SignUp2State extends State<SignUp2> {
  final TextEditingController p_firstnameController = TextEditingController();
  final TextEditingController p_lastnameController = TextEditingController();
  final TextEditingController p_HKIDController = TextEditingController();
  final TextEditingController p_emailController = auth.currentUser == null
      ? TextEditingController()
      : TextEditingController(text: auth.currentUser!.email);
  final TextEditingController p_passwordController = TextEditingController();
  final TextEditingController p_passwordretypeController =
      TextEditingController();

  final TextEditingController d_firstnameController = TextEditingController();
  final TextEditingController d_lastnameController = TextEditingController();
  final TextEditingController d_HKIDController = TextEditingController();
  String? specialty = "";
  int exp = 0;
  final TextEditingController d_emailController = auth.currentUser == null
      ? TextEditingController()
      : TextEditingController(text: auth.currentUser!.email);
  final TextEditingController d_passwordController = TextEditingController();
  final TextEditingController d_passwordretypeController =
      TextEditingController();

  bool nameError = false;
  bool idError = false;
  bool lastnameError = false;
  bool titleError = false;
  // bool expError = false;
  String pos = 'patient';
  String errorText = '';
  String profilePic = '';

  File? imgFile;
  bool hidePassword = true;
  int? _toggleValue = 0;

  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  @override
  void dispose() {
    p_emailController.clear();
    p_passwordController.clear();
    p_HKIDController.clear();
    p_passwordretypeController.clear();
    p_firstnameController.clear();
    p_lastnameController.clear();
    d_emailController.clear();
    d_passwordController.clear();
    d_HKIDController.clear();
    d_passwordretypeController.clear();
    d_firstnameController.clear();
    d_lastnameController.clear();

    super.dispose();
  }

  Future<void> getImg(String type) async {
    var img = await pickImage(type);
    setState(() {
      imgFile = img;
      // displayImg = Image.file(imgFile!);
    });
    return;
  }

  Future<void> p_register(BuildContext context) async {
    if (p_firstnameController.text.isEmpty ||
        p_lastnameController.text.isEmpty ||
        p_HKIDController.text.isEmpty) {
      errorText = "Please make sure you enter all the information.";
      Loading().hide();
      showAlertDialog(context, errorText);
      return;
    }

    if (auth.currentUser == null) {
      if (p_passwordController.text.isEmpty ||
          p_passwordretypeController.text.isEmpty) {
        errorText = "Please make sure you enter all the information.";
        Loading().hide();
        showAlertDialog(context, errorText);
        return;
      } else if (p_passwordController.text != p_passwordretypeController.text) {
        errorText = "Password not matched.";
        Loading().hide();
        showAlertDialog(context, errorText);
        return;
      }
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: p_emailController.text.trim(),
          password: p_passwordController.text,
        );
        print(auth.currentUser);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorText = 'Password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorText = 'Account already exists.';
        }
        Loading().hide();
        showAlertDialog(context, errorText);
        return;
      }
      if (!auth.currentUser!.emailVerified)
        await auth.currentUser!.sendEmailVerification();
    }
    User? user = auth.currentUser;

    if (user != null) {
      // await auth.currentUser?.updateDisplayName(_nicknameController.text);
      String uid = getUID();
      var respond = await writeToServer("patient/$uid", {
        'first name': p_firstnameController.text.trim(),
        'last name': p_lastnameController.text.trim(),
        'email': user.email,
        'HKID': p_HKIDController.text.trim(),
      });
      updateAuthInfo(
          p_firstnameController.text.trim() + p_lastnameController.text.trim());
    }

    // Chat - Authentication
    // Create Stream user and get token
    final callable = functions.httpsCallable('createStreamUserAndGetToken');
    final results = await callable();
    print('Stream account created, token: ${results.data}');
    // Chat - Authentication

    if (checkSignedin()) auth.signOut();
    if (await widget.google.isSignedIn()) await widget.google.signOut();
    Loading().hide();

    var result = await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => MessagePage(
                color: Colors.green,
                duration: 3,
                message:
                    'You have successfully registered.\nPlease verify your email before you login',
              )),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const welcome2()));
  }

  Future<void> d_register(BuildContext context) async {
    if (d_firstnameController.text.isEmpty ||
        d_lastnameController.text.isEmpty ||
        d_HKIDController.text.isEmpty ||
        specialty == "" ||
        imgFile == null) {
      Loading().hide();
      errorText = "Please make sure you enter all the information.";
      showAlertDialog(context, errorText);
      return;
    }

    if (auth.currentUser == null) {
      if (d_passwordController.text.isEmpty ||
          d_passwordretypeController.text.isEmpty) {
        Loading().hide();
        errorText = "Please make sure you enter all the information.";
        showAlertDialog(context, errorText);
        return;
      } else if (d_passwordController.text != d_passwordretypeController.text) {
        Loading().hide();
        errorText = "Password not matched.";
        showAlertDialog(context, errorText);
        return;
      }
      try {
        final credential = await auth.createUserWithEmailAndPassword(
          email: d_emailController.text.trim(),
          password: d_passwordController.text,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          errorText = 'Password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          errorText = 'Account already exists.';
        }
        Loading().hide();
        showAlertDialog(context, errorText);
        return;
      }
    }

    User? user = auth.currentUser;
    final String uid = getUID();

    String url = await uploadImage(imgFile!,
        d_firstnameController.text + d_lastnameController.text, 'None');

    var respond = await writeToServer("doctor/$uid", {
      'first name': d_firstnameController.text.trim(),
      'last name': d_lastnameController.text.trim(),
      'email': auth.currentUser!.email,
      'HKID': d_HKIDController.text.trim(),
      'profilePic': url,
      'title': specialty,
      'exp': exp.toString() + " years",
      '1': '0',
      '2': '0',
      '3': '0',
      '4': '0',
      '5': '0',
    });

    // Chat - Authentication
    // Create Stream user and get token
    final callable = functions.httpsCallable('createStreamUserAndGetToken');
    final results = await callable();
    print('Stream account created, token: ${results.data}');
    // Chat - Authentication

    if (checkSignedin()) auth.signOut();
    if (await widget.google.isSignedIn()) await widget.google.signOut();
    Loading().hide();
    //auth.signOut();
    var result = await Navigator.of(context).pushReplacement(
      MaterialPageRoute(
          builder: (context) => MessagePage(
                color: Colors.green,
                duration: 3,
                message:
                    'You have successfully registered.\nPlease verify your email before you login',
              )),
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const welcome2()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text('Sign Up'),
              elevation: 0,
              toolbarHeight: 80,
              backgroundColor: lighttheme,
              titleTextStyle: appbar_title,
              centerTitle: true,
              //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
              leading: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: defaultVerPadding / 2,
                      horizontal: defaultHorPadding / 1.5),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(1),
                          shadowColor: MaterialStatePropertyAll(themeColor),
                          side: MaterialStatePropertyAll(BorderSide(
                            width: 1,
                            color: themeColor,
                          )),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))))),
                      onPressed: () async {
                        if (auth.currentUser != null) {
                          bool? result = await showConfirmDialog(context,
                              "Are you sure to cancel the registration?");
                          if (result == true) {
                            Loading().show(context: context, text: "Loading");
                            await auth.currentUser!.delete();
                            Loading().hide();
                            Navigator.of(context).pop(true);
                          }
                        } else {
                          Navigator.of(context).pop(true);
                        }
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 23,
                        color: themeColor,
                      ))),
              leadingWidth: 95,
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Center(
                  child: SingleChildScrollView(
                      child: Column(children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    ToggleSwitch(
                      totalSwitches: 2,
                      initialLabelIndex: _toggleValue,
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      labels: ['Patient', 'Professional'],
                      radiusStyle: true,
                      cornerRadius: 20,
                      customTextStyles: [
                        GoogleFonts.comfortaa(
                            color: _toggleValue == 0
                                ? Colors.white
                                : Colors.black),
                        GoogleFonts.comfortaa(
                            color:
                                _toggleValue == 1 ? Colors.white : Colors.black)
                      ],
                      activeBgColor: [lighttheme, lighttheme, lighttheme],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.white,
                      onToggle: (index) {
                        setState(() {
                          _toggleValue = index;
                        });
                      },
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: defaultHorPadding,
                          vertical: defaultVerPadding),
                      margin: EdgeInsets.symmetric(
                          horizontal: defaultHorPadding / 2,
                          vertical: defaultVerPadding),
                      child: _toggleValue == 0
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: p_firstnameController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.person,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Firstname",
                                      hintText: 'same as HKID/passport',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: p_lastnameController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.person,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Lastname",
                                      hintText: 'same as HKID/passport',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: p_HKIDController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.email,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "HKID/Passport ID",
                                      hintText: 'A123456(7)',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: p_emailController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    readOnly:
                                        auth.currentUser == null ? false : true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: themeColor,
                                      ),
                                      filled: true,
                                      fillColor: auth.currentUser == null
                                          ? Colors.white
                                          : Color.fromARGB(255, 239, 239, 239),
                                      labelText: "Email",
                                      hintText: 'your-email@domain.com',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          auth.currentUser == null ? 20 : 0),
                                  child: auth.currentUser == null
                                      ? Form(
                                          child: TextFormField(
                                            controller: p_passwordController,
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                            obscuringCharacter: '*',
                                            obscureText: hidePassword,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]'))
                                            ],
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: themeColor,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Password",
                                              hintText: '*********',
                                              labelStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 47, 106, 173))),
                                              hintStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 148, 148, 148))),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hidePassword =
                                                          !hidePassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    hidePassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          auth.currentUser == null ? 20 : 0),
                                  child: auth.currentUser == null
                                      ? Form(
                                          child: TextFormField(
                                            controller:
                                                p_passwordretypeController,
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                            obscuringCharacter: '*',
                                            obscureText: hidePassword,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]'))
                                            ],
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: themeColor,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Re-Type Password",
                                              hintText: '*********',
                                              labelStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 47, 106, 173))),
                                              hintStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 148, 148, 148))),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hidePassword =
                                                          !hidePassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    hidePassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          minimumSize: MaterialStatePropertyAll(
                                              Size.fromHeight(
                                                  double.minPositive)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  themeColor),
                                          padding: MaterialStatePropertyAll(
                                              const EdgeInsets.symmetric(
                                                  vertical: 18))),
                                      onPressed: () async {
                                        Loading().show(
                                            context: context,
                                            text: "Loading...");
                                        await p_register(context);
                                      },
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.comfortaa(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                      ),
                                    ))
                              ],
                            )
                          : Column(
                              //Professional
                              children: [
                                InkWell(
                                    onTap: () async {
                                      String? option =
                                          await showOptionDialog(context);
                                      await getImg(option!);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.3,
                                      margin: EdgeInsets.only(
                                          bottom: defaultHorPadding,
                                          top: defaultHorPadding / 2),
                                      decoration: BoxDecoration(
                                          color: bgColor,
                                          //border: Border.all(color: themeColor),
                                          borderRadius:
                                              BorderRadius.circular(60),
                                          image: imgFile != null
                                              ? DecorationImage(
                                                  image: FileImage(imgFile!),
                                                  fit: BoxFit.cover)
                                              : null),
                                      child: imgFile == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              color: lighttheme,
                                              size: 40,
                                            )
                                          : null,
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: d_firstnameController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.person,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Firstname",
                                      hintText: 'same as HKID/passport',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: d_lastnameController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.person,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Lastname",
                                      hintText: 'same as HKID/passport',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: d_HKIDController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.email,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "HKID/Passport ID",
                                      hintText: 'A123456(7)',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: DropdownButtonFormField(
                                    items: <String>[
                                      "Allergy and Immunology",
                                      "Anesthesiology",
                                      "Dermatology",
                                      "Diagnostic radiology",
                                      "Emergency medicine",
                                      "Family medicine",
                                      "Internal medicine",
                                      "Medical genetics",
                                      "Others"
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: GoogleFonts.comfortaa(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      specialty = value as String?;
                                    },
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    menuMaxHeight:
                                        MediaQuery.of(context).size.height *
                                            0.3,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.email,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Specialty",
                                      hintText: '--Select Specialty--',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: SpinBox(
                                    min: 0,
                                    max: 50,
                                    onChanged: (value) {
                                      exp = value as int;
                                    },
                                    iconColor:
                                        MaterialStatePropertyAll(lighttheme),
                                    iconSize: 20,
                                    textStyle: GoogleFonts.comfortaa(),
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      // prefixIcon: const Icon(
                                      //   Icons.email,
                                      //   color: themeColor,
                                      // ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Experience",
                                      //hintText: 'A123456(7)',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: d_emailController,
                                    style: GoogleFonts.comfortaa(
                                        textStyle:
                                            TextStyle(color: Colors.black)),
                                    readOnly:
                                        auth.currentUser == null ? false : true,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(
                                          RegExp('[ ]'))
                                    ],
                                    decoration: InputDecoration(
                                      focusedBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      enabledBorder: const OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: themeColor),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: themeColor,
                                      ),
                                      filled: true,
                                      fillColor: auth.currentUser == null
                                          ? Colors.white
                                          : Color.fromARGB(255, 239, 239, 239),
                                      labelText: "Email",
                                      hintText: 'your-email@domain.com',
                                      labelStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(
                                          textStyle: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          auth.currentUser == null ? 20 : 0),
                                  child: auth.currentUser == null
                                      ? Form(
                                          child: TextFormField(
                                            controller: d_passwordController,
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                            obscuringCharacter: '*',
                                            obscureText: hidePassword,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]'))
                                            ],
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: themeColor,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Password",
                                              hintText: '*********',
                                              labelStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 47, 106, 173))),
                                              hintStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 148, 148, 148))),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hidePassword =
                                                          !hidePassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    hidePassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          auth.currentUser == null ? 20 : 0),
                                  child: auth.currentUser == null
                                      ? Form(
                                          child: TextFormField(
                                            controller:
                                                d_passwordretypeController,
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Colors.black)),
                                            obscuringCharacter: '*',
                                            obscureText: hidePassword,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                  RegExp('[ ]'))
                                            ],
                                            decoration: InputDecoration(
                                              focusedBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              enabledBorder:
                                                  const OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: themeColor),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              prefixIcon: const Icon(
                                                Icons.lock,
                                                color: themeColor,
                                              ),
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Re-Type Password",
                                              hintText: '*********',
                                              labelStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 47, 106, 173))),
                                              hintStyle: GoogleFonts.comfortaa(
                                                  textStyle: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 148, 148, 148))),
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      hidePassword =
                                                          !hidePassword;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    hidePassword
                                                        ? Icons.visibility_off
                                                        : Icons.visibility,
                                                  )),
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 0),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          minimumSize: MaterialStatePropertyAll(
                                              Size.fromHeight(
                                                  double.minPositive)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  themeColor),
                                          padding: MaterialStatePropertyAll(
                                              const EdgeInsets.symmetric(
                                                  vertical: 18))),
                                      onPressed: () async {
                                        Loading().show(
                                            context: context,
                                            text: "Loading...");
                                        await d_register(context);
                                      },
                                      child: Text(
                                        'Register',
                                        style: GoogleFonts.comfortaa(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                      ),
                                    ))
                              ],
                            ),
                    ),
                  ])),
                ))));
  }
}
