import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_helper.dart';
import 'main.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool nameError = false;
  bool idError = false;
  bool lastnameError = false;

  final _storage = const FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _lastnameController =
      TextEditingController(text: "");
  final TextEditingController _idController = TextEditingController(text: "");

  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  void register() async {
    nameError = lastnameError = idError = false;
    if (_nameController.text.isEmpty) {
      nameError = true;
    }
    if (_lastnameController.text.isEmpty) {
      lastnameError = true;
    }
    if (_idController.text.isEmpty) {
      idError = true;
    }
    if (nameError || lastnameError || idError) return;
    final String uid = await getUID();
    setDoc("doctor/$uid", {
      'first name': _nameController.text,
      'last name': _lastnameController.text,
      'email': auth.currentUser!.email,
      'HKID': _idController.text
    });
    updateAuthInfo(_nameController.text);
  }

  // void checkExist() async {
  //   final String uid = await getUID();
  //   print(await checkDocExist("patient/$uid"));
  // }

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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
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
                controller: _nameController,
                // cursorColor: Colors.orange,
                decoration: InputDecoration(
                  labelText: 'First Name:',
                  filled: nameError,
                  fillColor: Colors.red,
                  hintText: 'First Name',
                  // suffixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _lastnameController,
                decoration: InputDecoration(
                  labelText: 'Last Name:',
                  filled: lastnameError,
                  fillColor: Colors.red,
                  hintText: 'Last Name',
                  // suffixIcon: Icon(Icons.assignment_ind),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'HKID/Password No.:',
                  filled: idError,
                  fillColor: Colors.red,
                  hintText: 'HKID/Password No.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                nameError || lastnameError || idError ? 'Invalid input.' : '',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[900]),
                  ),
                  onPressed: register,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(10.0),
              //   child: ElevatedButton(
              //     child: Text('CheckExist'),
              //     style: ButtonStyle(
              //       backgroundColor:
              //           MaterialStateProperty.all(Colors.amber[900]),
              //     ),
              //     onPressed: checkExist,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
