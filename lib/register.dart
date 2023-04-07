import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'helper/firebase_helper.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'main.dart';
import 'dart:io';
import 'helper/message_page.dart';
import 'doctor/d_homepage.dart';
import 'patient/p_homepage.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool nameError = false;
  bool idError = false;
  bool lastnameError = false;
  bool titleError = false;
  bool expError = false;
  String pos = 'patient';
  String errorText = '';
  String profilePic = '';
  // Image? displayImg;
  File? imgFile;

  final _storage = const FlutterSecureStorage();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _lastnameController =
      TextEditingController(text: "");
  final TextEditingController _idController = TextEditingController(text: "");
  final TextEditingController _titleController =
      TextEditingController(text: "");
  final TextEditingController _expController = TextEditingController(text: "");

  final CollectionReference Users =
      FirebaseFirestore.instance.collection('users');

  void register(BuildContext context) async {
    if (!checkSignedin()) {
      setState(() {
        errorText = 'You have not signed up.';
      });
      Navigator.pop(context);
      return;
    }

    if (!checkEmailAuth()) {
      setState(() {
        errorText = 'Please vertify your email account first.';
      });
      return;
    }

    if (await patientOrdoc() != ID.NOBODY) {
      setState(() {
        errorText = 'You have already signed up.';
      });
      return;
    }

    nameError = lastnameError = idError = titleError = expError = false;
    if (_nameController.text.isEmpty) {
      nameError = true;
    }
    if (_lastnameController.text.isEmpty) {
      lastnameError = true;
    }
    if (_idController.text.isEmpty) {
      idError = true;
    }
    if (_titleController.text.isEmpty && pos == 'doctor') {
      titleError = true;
    }
    if (_expController.text.isEmpty && pos == 'doctor') {
      expError = true;
    }
    if (nameError || lastnameError || idError || titleError || expError) return;
    String url = '';
    final String uid = getUID();
    if (pos == 'doctor') {
      if (imgFile == null) {
        print("no img");
        return;
      }
      url = await uploadImage(
          imgFile!, _nameController.text + _lastnameController.text, 'None');
      print(url);
    }
    var respond = await writeToServer("$pos/$uid", {
      'first name': _nameController.text,
      'last name': _lastnameController.text,
      'email': auth.currentUser!.email,
      'HKID': _idController.text,
      if (pos == 'doctor') 'profilePic': url,
      if (pos == 'doctor') 'title': _titleController.text,
      if (pos == 'doctor') 'exp': _expController.text,
      if (pos == 'doctor')
        'rating': {
          '1': '0',
          '2': '0',
          '3': '0',
          '4': '0',
          '5': '0',
        },
    });
    updateAuthInfo(_nameController.text);
    var result = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => MessagePage(
                color: Colors.green,
                duration: 3,
                message: 'You have successfully registered.',
              )),
    );

    Navigator.pop(context);
    switch (await patientOrdoc()) {
      case ID.DOCTOR:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const d_HomePage()));
        break;
      case ID.PATIENT:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const p_HomePage()));
        break;
      case ID.ADMIN:
        break;
      case ID.NOBODY:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Register()));
        break;
    }
  }

  void checkExist() async {
    final String uid = getUID();
    // final String pos = await patientOrdocStr();
    print(await checkDocExist("$pos/$uid"));
    // var data = await getDoc("doctor/$uid");
    var data = await readFromServer("$pos/$uid");
    print(data!);
    print(data['first name']);
    print(data['last name']);
    print(data['rating']);
  }

  Future<void> getImg(String type) async {
    var img = await pickImage(type);
    setState(() {
      imgFile = img;
      // displayImg = Image.file(imgFile!);
    });
    return;
  }

  // void _toggleSwitch(String value) {
  //   setState(() {
  //     pos = value;
  //   });
  //   return;
  // }

  bool toggle = true;

  void toggleSwitch(int index) {
    if (index == 0) {
      setState(() {
        toggle = true;
      });
    } else if (index == 1) {
      setState(() {
        toggle = false;
      });
    }
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
              ToggleSwitch(
                minWidth: 90.0,
                cornerRadius: 20.0,
                activeBgColors: [
                  [Colors.blue[600]!],
                  [Colors.blue[600]!]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                initialLabelIndex: toggle ? 0 : 1,
                totalSwitches: 2,
                labels: ['Patient', 'Doctor'],
                radiusStyle: true,
                onToggle: (index) {
                  setState(() {
                    if (index == 0) {
                      pos = 'patient';
                    } else {
                      pos = 'doctor';
                    }
                  });
                  toggleSwitch(index!);
                },
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
              if (pos == 'doctor')
                TextField(
                  controller: _titleController, //TODO
                  decoration: InputDecoration(
                    labelText: 'Title:',
                    filled: titleError, //TODO
                    fillColor: Colors.red,
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              if (pos == 'doctor')
                SizedBox(
                  height: 20.0,
                ),
              if (pos == 'doctor')
                TextField(
                  controller: _expController,
                  decoration: InputDecoration(
                    labelText: 'Experience:',
                    filled: expError,
                    fillColor: Colors.red,
                    hintText: 'Experience',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              if (pos == 'doctor')
                SizedBox(
                  height: 20.0,
                ),
              Text(
                nameError || lastnameError || idError || titleError || expError
                    ? 'Invalid input.'
                    : errorText != ''
                        ? errorText
                        : '',
                style: TextStyle(fontSize: 18.0, color: Colors.red),
              ),
              if (pos == 'doctor')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ElevatedButton.icon(
                          onPressed: () async => await getImg('camera'),
                          icon: const Icon(Icons.camera),
                          label: const Text('camera')),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: ElevatedButton.icon(
                          onPressed: () async => await getImg('gallery'),
                          icon: const Icon(Icons.library_add),
                          label: const Text('Gallery')),
                    ),
                  ],
                ),
              if (imgFile != null)
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.file(imgFile!)),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: ElevatedButton(
                  child: Text('Submit'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[900]),
                  ),
                  onPressed: () => register(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: ElevatedButton(
                  child: Text('CheckExist'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[900]),
                  ),
                  onPressed: checkExist,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
