import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'helper/loading/loading_popup.dart';
import 'helper/alert.dart';

import 'package:simple_login/patient/p_homepage.dart';
import 'package:simple_login/register.dart';
import 'doctor/d_homepage.dart';
import 'package:simple_login/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:simple_login/helper/ImageUpDownload.dart';
import 'main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'helper/firebase_helper.dart';
import 'helper/loading_screen.dart';
import 'helper/message_page.dart';
import 'forget_password.dart';


class welcome extends StatefulWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
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
      }
    }
    // if (credential?.user?.emailVerified == false) {
    //   await auth.currentUser?.sendEmailVerification();
    //   if (auth.currentUser?.emailVerified == true) return true;
    //   return 3;
    // }
    return 4;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
        child: Container(
                decoration: BoxDecoration(
                              color: Color.fromARGB(255, 47, 106, 173).withOpacity(0.25),
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
                          Container(
                            padding: const EdgeInsets.all(35),
                            child: Image.asset(
                            'assets/yoga.png',
                            height: 120,
                            width: 130,
                          ),),
                          
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
                            height: 450,
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20, bottom: 20, top: 20),
                                  child: TextFormField(
                                    controller: _usernameController,
                                    style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black)),
                                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                                    decoration: InputDecoration(
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.all(Radius.circular(10))),
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Color.fromARGB(255, 47, 106, 173),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Email",
                                      hintText: 'your-email@domain.com',
                                      labelStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173))),
                                      hintStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 148, 148, 148))),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                  child: Form(
                                    child: TextFormField(
                                      controller: _passwordController,
                                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black)),
                                      obscuringCharacter: '*',
                                      obscureText: hidePassword,
                                      inputFormatters: [FilteringTextInputFormatter.deny(RegExp('[ ]'))],
                                      decoration: InputDecoration(
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        prefixIcon: Icon(
                                          Icons.lock,
                                          color: Color.fromARGB(255, 47, 106, 173),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: "Password",
                                        hintText: '*********',
                                        labelStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173))),
                                        hintStyle: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 148, 148, 148))),
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
                                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), 
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0)),
                                            backgroundColor: Color.fromARGB(255, 47, 106, 173),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 128, vertical: 17)
                                            ),
                                        onPressed: () async {
                                          if (_usernameController.text != "" && _passwordController.text != "") {
                                            Loading().show(context: context, text: "Logging in...");
                                            var msg = await _firestoreLogin();
                                            Loading().hide();
                                            if (msg == 1) {
                                                showAlertDialog(context, "Account Not Found");
                                            } else if (msg == 2) {
                                                showAlertDialog(context, "Invalid Password");
                                            } else if (msg == 3) {
                                                showAlertDialog(context, "Your Email is not verified");
                                            } else {
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
                                                  showAlertDialog(context, 'Please authenticate your email.\nIf you could not find it, please check junk mail.');
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => MessagePage(
                                                  //             duration: 5,
                                                  //             color: Colors.blue,
                                                  //             message:
                                                  //                 'Please authenticate your email.\nIf you could not find it, please check junk mail.')));
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
                                          }
                                          else { showAlertDialog(context, "Please enter Email and Password"); }
                                            
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => loginScreen()));
                                        },
                                        child: Text(
                                          'Sign In',
                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),
                                        )),
                                    ),
                                
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Forget password',
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w300, fontSize: 15)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                            },
                                            child: Text(
                                              'Reset Password',
                                              style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173), fontWeight: FontWeight.w700, fontSize: 15)))
                                          ),
                                        ],
                                      ),
                                
                                // or continue with
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        indent: 20,
                                        endIndent: 20,
                                        height: 0,
                                        thickness: 1,
                                        color: Color.fromARGB(255, 47, 106, 173),
                                      ),
                                    ),
                                    Text(
                                          'OR',
                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173),))
                                        ),
                                    Expanded(
                                      child: Divider(
                                        indent: 20,
                                        endIndent: 20,
                                        height: 0,
                                        thickness: 1,
                                        color: Color.fromARGB(255, 47, 106, 173),
                                      ),
                                    ),
                                  ],
                                ),

                                //Login with Google
                                Padding(
                                  padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 15  ),
                                  child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0)),
                                            backgroundColor: Color.fromARGB(255, 242, 243, 244),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 41, vertical: 7)
                                            ),
                                        onPressed: () {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                  content: Text('Logging in with Google')),
                                            );
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
                                        icon: Image.asset('assets/google.png', alignment: Alignment.centerLeft, scale: 14,),
                                        label: Text(
                                          'Continue with Google',
                                          style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 17)),
                                        )),
                                ),

                                        Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Don\'t have any account?',
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w300, fontSize: 15)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(builder: (context) => Signup()));
                                            },
                                            child: Text(
                                              'Sign Up',
                                              style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173), fontWeight: FontWeight.w700, fontSize: 15)))
                                          ),
                                        ],
                                      ),
                                      //TODO
                                      // Row(
                                      //   mainAxisAlignment: MainAxisAlignment.center,
                                      //   children: [
                                      //     Text(
                                      //       'Forget password',
                                      //       style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black.withOpacity(0.7), fontWeight: FontWeight.w300, fontSize: 15)),
                                      //     ),
                                      //     TextButton(
                                      //       onPressed: () {
                                      //         Navigator.push(context,
                                      //             MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
                                      //       },
                                      //       child: Text(
                                      //         'Reset Password',
                                      //         style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173), fontWeight: FontWeight.w700, fontSize: 15)))
                                      //     ),
                                      //   ],
                                      // ),
                              ],
                            ),
                          ), 
                        ],
                      ),
                    ),
                  ),
                ),
              ),)
    );
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
