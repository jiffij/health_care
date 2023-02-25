/*
// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:simple_login/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_login/ImageUpDownload.dart';
import 'SendbirdChatView.dart'; // Sendbird Chat Test
import 'StreamChatChannelListPreview.dart'; // Stream Chat Test
import 'AgoraConfigWithUIKit.dart'; // Agora Video Call Test
import 'main.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
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
    await _storage.write(key: "KEY_USERNAME", value: _usernameController.text);
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
    return true; //this line is just for testing and should be deleted
    var credential;
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: _usernameController.text, password: _passwordController.text);
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
    // print(auth.currentUser!);
    if (credential.user.emailVerified == false) {
      await auth.currentUser?.sendEmailVerification();
      if (auth.currentUser?.emailVerified == true) return true;
      return false;
    }

    return true;
  }

  _login() async {
    await _readFromStorage();
    print(UserName + Password);
    if (UserName != null && Password != null) {
      if (UserName == _usernameController.text &&
          Password == _passwordController.text) {
        setState(() {
          LoginSuccess = true;
        });
        print('login success');
        return true;
      }
    }
    print('login fail');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(30.0),
            height: height,
            width: width,
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15.0),
                    width: width,
                    height: height * 0.45,
                    child: Image.asset(
                      'assets/yoga.png',
                      fit: BoxFit.fill,
                    ),
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
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 25.0),
                    child: ElevatedButton(
                      child: Text('Login'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.amber)),
                      onPressed: () async {
                        if (_usernameController.text != '' &&
                            _passwordController.text != '' &&
                            await _firestoreLogin()) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomePage())); // Agora Video Call Test
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Signup()));
                    },
                    child: Text.rich(
                      TextSpan(text: 'Don\'t have an account? ', children: [
                        TextSpan(
                          text: 'Signup!',
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
  final _storage = const FlutterSecureStorage();
  final TextEditingController _usernameController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final TextEditingController _nicknameController =
      TextEditingController(text: "");

  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  //local storing password
  _onFormSubmit() async {
    await _storage.write(key: "KEY_USERNAME", value: _usernameController.text);
    await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
    print('signed up');
  }

  //firestore auth
  _signup() async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    User? user = auth.currentUser;

    if (user != null) {
      await auth.currentUser?.updateDisplayName(_nicknameController.text);
      if (!user.emailVerified) await user.sendEmailVerification();
    }
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
    //create a document
    // return Users.add({
    //   'Id': _usernameController.text,
    //   'Password': _passwordController.text,
    // })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(30.0),
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
                controller: _nicknameController,
                decoration: InputDecoration(
                  hintText: 'User Name',
                  suffixIcon: Icon(Icons.assignment_ind),
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
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 30.0,
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
                            MaterialStateProperty.all(Colors.amber),
                      ),
                      onPressed: () async {
                        // await _onFormSubmit();
                        // await addUser();
                        if (_nicknameController.text != '' &&
                            _passwordController.text != '' &&
                            _usernameController.text != '') {
                          await _signup();
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
                  TextSpan(text: 'Already have an account? ', children: [
                    TextSpan(
                      text: 'Login!',
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
*/