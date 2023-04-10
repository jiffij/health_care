import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/color.dart';
import 'helper/loading/loading_popup.dart';
import 'helper/alert.dart';

import 'main.dart';

class welcome extends StatefulWidget {
  const welcome({Key? key}) : super(key: key);

  @override
  State<welcome> createState() => _welcomeState();
}

class _welcomeState extends State<welcome> {
  final _storage = const FlutterSecureStorage();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;

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
      else if (e.code == 'too-many-requests') {
        return 5;
      }
    }
    if (credential?.user?.emailVerified == false) {
      await auth.currentUser?.sendEmailVerification();
      if (auth.currentUser?.emailVerified == true) return true;
      return 3;
    }
    return 4;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {FocusScope.of(context).requestFocus(FocusNode());},
        child: Container(
                decoration: const BoxDecoration(
                              color: bgColor,
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
                            height: 130,
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
                            height: 410,
                            width: MediaQuery.of(context).size.width / 1.1,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.4),
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
                                      labelText: "Email",
                                      hintText: 'your-email@domain.com',
                                      labelStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: themeColor)),
                                      hintStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Color.fromARGB(255, 148, 148, 148))),
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
                                        focusedBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: themeColor),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        enabledBorder: const OutlineInputBorder(
                                            borderSide: BorderSide(color: themeColor),
                                            borderRadius:
                                                BorderRadius.all(Radius.circular(10))),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: themeColor,
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
                                            backgroundColor: themeColor,
                                            padding: const EdgeInsets.symmetric(
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
                                            } 
                                            else if (msg == 5) {
                                              showAlertDialog(context, "You have tried too many times.\nPlease try again later.");
                                            }
                                            else {
                                                showAlertDialog(context, "Login Success");
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
                                
                                
                                // or continue with
                                Row(
                                  children: [
                                    const Expanded(
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
                                          
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) => loginScreen()));
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
                                            onPressed: () {},
                                            child: Text(
                                              'Sign Up',
                                              style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 47, 106, 173), fontWeight: FontWeight.w700, fontSize: 15)))
                                          ),
                                        ],
                                      ),
                                      
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