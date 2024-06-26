import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_login/yannie_version/color.dart';
import 'package:simple_login/login_screen.dart';
import 'package:simple_login/register.dart';
import 'package:simple_login/yannie_version/pages/yannie_home.dart';
import 'package:simple_login/yannie_version/pages/yannie_signup.dart';
import '../../doctor/d_homepage.dart';
import '../../forget_password.dart';
import '../../helper/firebase_helper.dart';
import '../../helper/loading/loading_popup.dart';
import '../../helper/alert.dart';

import '../../main.dart';
import '../../new_doctor/pages/yannie_home.dart';
import '../widget/navigator.dart';
import '../../new_doctor/widget/navigator.dart' as DoctorNav;

// Chat - Authentication
import 'package:cloud_functions/cloud_functions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'; // Chat

String userToken = 'TokenTest';
// Chat - Authentication

class welcome2 extends StatefulWidget {
  const welcome2({Key? key}) : super(key: key);

  @override
  State<welcome2> createState() => _welcome2State();
}

class _welcome2State extends State<welcome2> {
  final _storage = const FlutterSecureStorage();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;
  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  @override
  initState() {
    super.initState();
    signOut();
  }

  @override
  void dispose() {
    _usernameController.clear();
    _passwordController.clear();
    super.dispose();
  }

  _firestoreLogin() async {
    UserCredential? credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        return 1;
      } else if (e.code == 'wrong-password') {
        return 2;
      } else if (e.code == 'too-many-requests') {
        return 5;
      }
    }
    if (credential?.user?.emailVerified == false) {
      await auth.currentUser?.sendEmailVerification();
      signOut();
      return 3;
    }
    return 4;
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    await signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    // Chat - Authentication
    /*
    // Revoke Stream user token.
    final callable = functions.httpsCallable('revokeStreamUserToken');
    await callable();
    print('Stream user token revoked');
    */
    // Chat - Authentication

    if (checkSignedin()) await auth.signOut();
    if (await googleSignIn.isSignedIn()) await googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Container(
            decoration: const BoxDecoration(
                //color: bgColor,
                ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // logo image
                      // Container(
                      //   padding: const EdgeInsets.all(35),
                      //   child: Image.asset(
                      //   'assets/yoga.png',
                      //   height: 130,
                      //   width: 130,
                      // ),),

                      //App Name
                      Text(
                        'Dr. UST',
                        style: GoogleFonts.comfortaa(
                          textStyle: const TextStyle(
                            color: Color.fromARGB(255, 47, 106, 173),
                            fontWeight: FontWeight.w100,
                            fontSize: 40,
                          ),
                        ),
                      ),

                      //Space between App Name and Login Form
                      const SizedBox(
                        height: 30,
                      ),

                      //container for login form
                      Container(
                        //height: MediaQuery.of(context).size.height*0.54,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: defaultHorPadding,
                                right: defaultHorPadding,
                                top: defaultVerPadding,
                                bottom: defaultVerPadding / 3),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: TextFormField(
                                    controller: _usernameController,
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
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: themeColor,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
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
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Form(
                                    child: TextFormField(
                                      controller: _passwordController,
                                      style: GoogleFonts.comfortaa(
                                          textStyle:
                                              TextStyle(color: Colors.black)),
                                      obscuringCharacter: '*',
                                      obscureText: hidePassword,
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
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            icon: Icon(
                                              hidePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
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
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());
                                        if (_usernameController.text != "" &&
                                            _passwordController.text != "") {
                                          Loading().show(
                                              context: context,
                                              text: "Loading...");
                                          var msg = await _firestoreLogin();
                                          Loading().hide();
                                          if (msg == 1) {
                                            await showAlertDialog(context,
                                                    "Account Not Found")
                                                .then((_) {
                                              Navigator.push(
                                                  context,
                                                  _createRoute(SignUp2(
                                                      google: googleSignIn)));
                                            });
                                          } else if (msg == 2) {
                                            showAlertDialog(
                                                context, "Invalid Password");
                                          } else if (msg == 3) {
                                            await showAlertDialog(context,
                                                    "Your Email is not verified")
                                                .then((_) {
                                              auth
                                                  .checkActionCode(
                                                      auth.currentUser!.email!)
                                                  .then((ActionCodeInfo
                                                      info) async {
                                                if (info.operation ==
                                                    ActionCodeInfoOperation
                                                        .verifyEmail) {
                                                  // The email verification link is still valid
                                                  // Apply the action by calling the applyActionCode method
                                                  auth
                                                      .applyActionCode(auth
                                                          .currentUser!.email!)
                                                      .then((value) {
                                                    // Email verified successfully
                                                  }).catchError((error) {
                                                    // Handle any errors that occur during the applyActionCode call
                                                  });
                                                } else {
                                                  // The link has expired or is invalid
                                                  // Display an error message or take appropriate action
                                                  await auth.currentUser!
                                                      .sendEmailVerification();
                                                }
                                              }).catchError((error) {
                                                // Handle any errors that occur during the checkActionCode call
                                              });
                                              showAlertDialog(context,
                                                  'Please authenticate your email.\nIf you could not find it, please check junk mail.');
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) => MessagePage(
                                              //             duration: 5,
                                              //             color: Colors.blue,
                                              //             message:
                                              //                 'Please authenticate your email.\nIf you could not find it, please check junk mail.')));
                                              return;
                                            });
                                          } else if (msg == 5) {
                                            await showAlertDialog(context,
                                                "You have tried too many times.\nPlease try again later.");
                                          } else {
                                            await showSuccessDialog(
                                                context, "Login Success");
                                            // Chat - Authentication
                                            // Get Stream user token
                                            final callable =
                                                functions.httpsCallable(
                                                    'getStreamUserToken');
                                            final results = await callable();
                                            print(
                                                'Stream user token retrieved: ${results.data}');

                                            userToken = '${results.data}';
                                            // Chat - Authentication
                                            if (FirebaseAuth
                                                    .instance.currentUser !=
                                                null) {
                                              switch (await patientOrdoc()) {
                                                case ID.DOCTOR:
                                                  // Chat - Authentication
                                                  // Get Stream user token
                                                  final callable =
                                                      functions.httpsCallable(
                                                          'getStreamUserToken');
                                                  final results =
                                                      await callable();
                                                  print(
                                                      'Stream user token retrieved: ${results.data}');

                                                  userToken = '${results.data}';
                                                  // Chat - Authentication
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DoctorNav
                                                                  .BottomNav()));
                                                  break;
                                                case ID.PATIENT:
                                                  // Chat - Authentication
                                                  // Get Stream user token
                                                  final callable =
                                                      functions.httpsCallable(
                                                          'getStreamUserToken');
                                                  final results =
                                                      await callable();
                                                  print(
                                                      'Stream user token retrieved: ${results.data}');

                                                  userToken = '${results.data}';
                                                  // Chat - Authentication
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const BottomNav()));
                                                  break;
                                                case ID.ADMIN:
                                                  break;
                                                case ID.NOBODY:
                                                  Navigator.of(context).push(
                                                      _createRoute(SignUp2(
                                                          google:
                                                              googleSignIn)));
                                                  break;
                                              }
                                            }
                                            ;
                                          }
                                        } else {
                                          showAlertDialog(context,
                                              "Please enter Email and Password");
                                        }
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: GoogleFonts.comfortaa(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                      )),
                                ),

                                // or continue with
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Divider(
                                        indent: 0,
                                        endIndent: 10,
                                        height: 0,
                                        thickness: 1,
                                        color:
                                            Color.fromARGB(255, 47, 106, 173),
                                      ),
                                    ),
                                    Text('OR',
                                        style: GoogleFonts.comfortaa(
                                            textStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 47, 106, 173),
                                        ))),
                                    Expanded(
                                      child: Divider(
                                        indent: 10,
                                        endIndent: 0,
                                        height: 0,
                                        thickness: 1,
                                        color:
                                            Color.fromARGB(255, 47, 106, 173),
                                      ),
                                    ),
                                  ],
                                ),

                                //Login with Google
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: ElevatedButton.icon(
                                      style: ButtonStyle(
                                          overlayColor: MaterialStatePropertyAll(
                                              Colors.white),
                                          minimumSize: MaterialStatePropertyAll(
                                              Size.fromHeight(
                                                  double.minPositive)),
                                          shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0))),
                                          backgroundColor: MaterialStatePropertyAll(
                                              Color.fromARGB(
                                                  255, 242, 243, 244)),
                                          padding: MaterialStatePropertyAll(
                                              EdgeInsets.symmetric(vertical: 10))),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Logging in with Google')),
                                        );

                                        signInWithGoogle().then((value) async {
                                          // print(FirebaseAuth.instance.authStateChanges());
                                          /*
                                          // Chat - Authentication
                                          // Get Stream user token
                                          final callable =
                                              functions.httpsCallable(
                                                  'getStreamUserToken');
                                          final results = await callable();
                                          print(
                                              'Stream user token retrieved: ${results.data}');

                                          userToken = '${results.data}';
                                          // Chat - Authentication
                                          */
                                          print(FirebaseAuth
                                              .instance.currentUser
                                              .toString());
                                          if (FirebaseAuth
                                                  .instance.currentUser !=
                                              null) {
                                            switch (await patientOrdoc()) {
                                              case ID.DOCTOR:
                                                // Chat - Authentication
                                                // Get Stream user token
                                                final callable =
                                                    functions.httpsCallable(
                                                        'getStreamUserToken');
                                                final results =
                                                    await callable();
                                                print(
                                                    'Stream user token retrieved: ${results.data}');

                                                userToken = '${results.data}';
                                                // Chat - Authentication
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const DoctorNav
                                                                .BottomNav()));
                                                break;
                                              case ID.PATIENT:
                                                // Chat - Authentication
                                                // Get Stream user token
                                                final callable =
                                                    functions.httpsCallable(
                                                        'getStreamUserToken');
                                                final results =
                                                    await callable();
                                                print(
                                                    'Stream user token retrieved: ${results.data}');

                                                userToken = '${results.data}';
                                                // Chat - Authentication
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const BottomNav()));
                                                break;
                                              case ID.ADMIN:
                                                break;
                                              case ID.NOBODY:
                                                Navigator.push(
                                                    context,
                                                    _createRoute(SignUp2(
                                                        google: googleSignIn)));
                                                break;
                                            }
                                          }
                                        }).catchError((e) => print(e));
                                      },
                                      icon: Image.asset(
                                        'assets/google.png',
                                        alignment: Alignment.centerLeft,
                                        scale: 14,
                                      ),
                                      label: Text(
                                        'Continue with Google',
                                        style: GoogleFonts.comfortaa(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                      )),
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Don\'t have any account?',
                                      style: GoogleFonts.comfortaa(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.black.withOpacity(0.7),
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15)),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          signOut();
                                          Navigator.of(context).push(
                                              _createRoute(SignUp2(
                                                  google: googleSignIn)));
                                        },
                                        child: Text('Sign Up',
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 47, 106, 173),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15)))),
                                  ],
                                ),

                                //forget password
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Text(
                                    //   'Forget password?',
                                    //   style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w300, fontSize: 15)),
                                    // ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              _createRoute(
                                                  ForgotPasswordPage()));
                                        },
                                        child: Text('Forget Password',
                                            style: GoogleFonts.comfortaa(
                                                textStyle: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 47, 106, 173),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 15)))),
                                  ],
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

Route _createRoute(Widget destinition) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinition,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
