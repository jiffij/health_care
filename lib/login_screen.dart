// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_login/patient/p_homepage.dart';
import 'package:simple_login/register.dart';
import 'doctor/d_homepage.dart';
import 'package:simple_login/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_login/helper/ImageUpDownload.dart';
import 'main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'helper/firebase_helper.dart';
import 'helper/loading_screen.dart';
import 'helper/message_page.dart';
import 'forget_password.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final _storage = const FlutterSecureStorage();
  bool hidePassword = true, LoginSuccess = false;
  final TextEditingController _usernameController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  var UserName, Password;
  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  _onFormSubmit() async {
    await _storage.write(
        key: "KEY_USERNAME", value: _usernameController.text.trim());
    await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
  }

  Future<void> _readFromStorage() async {
    // var temp;
    // temp = await _storage.read(key: "KEY_USERNAME") ?? '';
    // setState(() {
    //   UserName = temp;
    // });
    // temp = await _storage.read(key: "KEY_PASSWORD") ?? '';
    // setState(() {
    //   Password = temp;
    // });
    UserName = await _storage.read(key: "KEY_USERNAME") ?? '';
    Password = await _storage.read(key: "KEY_PASSWORD") ?? '';
  }

  _firestoreLogin() async {
    dynamic credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: _usernameController.text.trim(),
          password: _passwordController.text);
      print(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return false;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return false;
      }
    }
    return true;
    // if (auth.currentUser?.emailVerified == true) {
    //   return true;
    // } else {
    //   await auth.currentUser?.sendEmailVerification();
    //   if (auth.currentUser?.emailVerified == true) return true;
    //   return false;
    // }
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
    if (!checkSignedin()) return;
    await googleSignIn.signOut();
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            height: height,
            width: width,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    width: width,
                    height: height * 0.45,
                    child: Image.asset(
                      'assets/yoga.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    'Login',
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      suffixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: _passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text('Login'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    onPressed: () async {
                      if (_usernameController.text != '' &&
                          _passwordController.text != '' &&
                          await _firestoreLogin()) {
                        if (!checkEmailAuth()) {
                          auth
                              .checkActionCode(auth.currentUser!.email!)
                              .then((ActionCodeInfo info) async {
                            if (info.operation ==
                                ActionCodeInfoOperation.verifyEmail) {
                              // The email verification link is still valid
                              // Apply the action by calling the applyActionCode method
                              auth
                                  .applyActionCode(auth.currentUser!.email!)
                                  .then((value) {
                                // Email verified successfully
                              }).catchError((error) {
                                // Handle any errors that occur during the applyActionCode call
                              });
                            } else {
                              // The link has expired or is invalid
                              // Display an error message or take appropriate action
                              await auth.currentUser!.sendEmailVerification();
                            }
                          }).catchError((error) {
                            // Handle any errors that occur during the checkActionCode call
                          });

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagePage(
                                      duration: 5,
                                      color: Colors.blue,
                                      message:
                                          'Please authenticate your email.\nIf you could not find it, please check junk mail.')));
                          return;
                        }

                        if (FirebaseAuth.instance.currentUser != null) {
                          switch (await patientOrdoc()) {
                            case ID.DOCTOR:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const d_HomePage()));
                              break;
                            case ID.PATIENT:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const p_HomePage()));
                              break;
                            case ID.ADMIN:
                              break;
                            case ID.NOBODY:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                              break;
                          }
                        }
                      }
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    child: Text('Google Login'),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber)),
                    onPressed: () async {
                      signInWithGoogle().then((value) async {
                        // print(FirebaseAuth.instance.authStateChanges());
                        print(FirebaseAuth.instance.currentUser.toString());
                        if (FirebaseAuth.instance.currentUser != null) {
                          switch (await patientOrdoc()) {
                            case ID.DOCTOR:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const d_HomePage()));
                              break;
                            case ID.PATIENT:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const p_HomePage()));
                              break;
                            case ID.ADMIN:
                              break;
                            case ID.NOBODY:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Register()));
                              break;
                          }
                        }
                      }).catchError((e) => print(e));
                    },
                  ),
                   SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text.rich(
                      TextSpan(text: 'Don\'t have an account ', children: [
                        TextSpan(
                          text: 'Signup',
                          style: TextStyle(color: Color(0xffEE7B23)),
                        ),
                      ]),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                    },
                    child: Text.rich(
                      TextSpan(text: 'Forget password ', children: [
                        TextSpan(
                          text: 'Reset Password',
                          style: TextStyle(color: Color(0xffEE7B23)),
                        ),
                      ]),
                    ),
                  ),
                ]))));
  }
}

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool hidePassword = true;
  bool hideRePassword = true;
  bool email_error = false;
  // bool user_name_error = false;
  bool password_error = false;

  final _storage = const FlutterSecureStorage();
  final TextEditingController _usernameController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  // final TextEditingController _nicknameController =
  //     TextEditingController(text: "");
  final TextEditingController _retypePasswordController =
      TextEditingController(text: "");

  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  //local storing password
  _onFormSubmit() async {
    await _storage.write(
        key: "KEY_USERNAME", value: _usernameController.text.trim());
    await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
    print('signed up');
  }

  //firestore auth
  Future<bool> _signup() async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
    User? user = auth.currentUser;

    if (user != null) {
      // await auth.currentUser?.updateDisplayName(_nicknameController.text);
      if (!user.emailVerified) await user.sendEmailVerification();
    }
    return true;
  }

  //firestore
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return Users.doc('IqiiKy77UeuLI4SpjyPb')
        .set({
          'users': {
            _usernameController.text: {'Password': _passwordController.text}
          }
        }, SetOptions(merge: true))
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.35,
                child: Image.asset(
                  'assets/play.png',
                  fit: BoxFit.fill,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Signup',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                controller: _usernameController,
                // cursorColor: Colors.orange,
                decoration: InputDecoration(
                  filled: email_error,
                  fillColor: Colors.red,
                  hintText: 'Email',
                  suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // TextField(
              //   controller: _nicknameController,
              //   decoration: InputDecoration(
              //     filled: user_name_error,
              //     fillColor: Colors.red,
              //     hintText: 'User Name',
              //     suffixIcon: Icon(Icons.assignment_ind),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(20.0),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20.0,
              // ),
              TextField(
                controller: _passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  filled: password_error,
                  fillColor: Colors.red,
                  hintText: 'Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _retypePasswordController,
                obscureText: hideRePassword,
                decoration: InputDecoration(
                  filled: password_error,
                  fillColor: Colors.red,
                  hintText: 'Retype Your Password',
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hideRePassword = !hideRePassword;
                        });
                      },
                      icon: Icon(
                        hideRePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              Text(
                email_error || password_error ? 'Invalid input.' : '',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forget password?',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    ElevatedButton(
                      child: Text('Signup'),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber[900]),
                      ),
                      onPressed: () async {
                        // await _onFormSubmit();
                        // await addUser();
                        bool email = false;
                        // bool user_name = false;
                        bool password = false;
                        RegExp regex = RegExp(r'\S+@\S+\.\S+');
                        if (_usernameController.text == '' ||
                            !regex.hasMatch(_usernameController.text)) {
                          setState(() {
                            email_error = true;
                          });
                        } else {
                          email_error = false;
                          email = true;
                        }

                        // if (_nicknameController.text == '') {
                        //   setState(() {
                        //     user_name_error = true;
                        //   });
                        // } else {
                        //   user_name_error = false;
                        //   user_name = true;
                        // }

                        if (_passwordController.text == '' ||
                            _passwordController.text !=
                                _retypePasswordController.text) {
                          setState(() {
                            password_error = true;
                          });
                        } else {
                          password_error = false;
                          password = true;
                        }
                        if (email && password) {
                          var go = await _signup();
                          if (go)
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => MessagePage(
                                        duration: 6,
                                        color: Colors.blue,
                                        message:
                                            'Please authenticate your email.\nIf you could not find it, please check junk mail.',
                                      )),
                            );
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => loginScreen()));
                  Navigator.pop(context);
                },
                child: Text.rich(
                  TextSpan(text: 'Already have an account', children: [
                    TextSpan(
                      text: 'Signin',
                      style: TextStyle(color: Color(0xffEE7B23)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
