import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/helper/loading_screen.dart';

import '../../helper/firebase_helper.dart';


class p_MedicalAllergyPage extends StatefulWidget {
  const p_MedicalAllergyPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<p_MedicalAllergyPage> createState() => _MedicalAllergyPageState();
}

class _MedicalAllergyPageState extends State<p_MedicalAllergyPage> {
  
  bool startDone = false;
  
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    

    return !startDone
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                heading(width, height),
                detaillist(width, height),
                modifybutton(width, height),

              ],
            ),
          );
  }

  String fullname = '';
  bool mdshow = false;
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _contactController =
      TextEditingController(text: "");
  final TextEditingController _relationController =
      TextEditingController(text: "");
  final TextEditingController _allergyController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() async {
    String uid = getUID();
    Map<String, dynamic>? data = await readFromServer('patient/$uid');
    Map<String, dynamic>? emergencydata =
        await readFromServer('patient/$uid/emergency/emergency');
    print(emergencydata);
    if (emergencydata != null) {
      _nameController.text = emergencydata['emergency contact name'];
      _contactController.text = emergencydata['emergency contact phone number'];
      _relationController.text = emergencydata['emergency contact relation'];
      _allergyController.text = emergencydata['allergy record'];
    }
    defaultText();
    setState(() {
      fullname = data?['first name'] + ' ' + data?['last name'];
      print(fullname);
      startDone = true;
    });
  }

  void defaultText() {
    if (_nameController.text == "") {
      _nameController.text = "There is no emergency contact name";
    }
    if (_contactController.text == "") {
      _contactController.text = "There is no emergency contact phone number";
    }
    if (_relationController.text == "") {
      _relationController.text = "There is no emergency contact relation";
    }
    if (_allergyController.text == "") {
      _allergyController.text = "There is no allergy details";
    }
  }

  void updateEmergencyDetail() {
    var uid = getUID();
    print(uid);
    print("Writing to server");
    writeToServer("patient/$uid/emergency/emergency", {
      'emergency contact name': _nameController.text,
      'emergency contact phone number': _contactController.text,
      'emergency contact relation': _relationController.text,
      'allergy record': _allergyController.text,
    });
    setState(() {});
  }

  Widget heading(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Stack(
          children: [
            Container(
              width: globalwidth,
              height: globalheight * 0.31,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            Container(
              width: globalwidth,
              height: globalheight * 0.25,
              color: const Color.fromARGB(255, 28, 107, 164),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        margin: const EdgeInsets.only(left: 15, top: 20),
                        height: globalheight * 0.06,
                        width: globalheight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            child: const Icon(Icons.arrow_back_rounded),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Personal Emergency Details',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Container(
                  margin: const EdgeInsets.only(left: 15, top: 10),
                  height: globalheight * 0.12,
                  width: globalwidth * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 220, 237, 249),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(255, 0, 0, 0),
                        blurRadius: 0.5,
                        offset: Offset(0.5, 0.5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 5),
                        width: globalheight * 0.1,
                        height: globalheight * 0.1,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const FittedBox(
                          fit: BoxFit.cover,
                          child: Icon(Icons.person,
                              color: Color.fromARGB(255, 123, 141, 158)),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: Text('User Full Name: $fullname',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget detaillist(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 12, top: 12, bottom: 5),
                      height: globalheight * 0.05,
                      width: globalwidth,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('Emergency Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 12),
                      width: globalwidth,
                      height: globalheight * 0.15,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Emergency Contact Name:',
                                style: TextStyle(fontSize: 16)),
                            Text(_nameController.text,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Emergency Contact Phone Number:',
                                style: TextStyle(fontSize: 16)),
                            Text(_contactController.text,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            const Text('Emergency Contact Relation:',
                                style: TextStyle(fontSize: 16)),
                            Text(_relationController.text,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 12, top: 12, bottom: 5),
                      height: globalheight * 0.05,
                      width: globalwidth,
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text('Allergy Details',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12, bottom: 12),
                      width: globalwidth,
                      height: globalheight * 0.15,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_allergyController.text,
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            mdshow ? modifypage(globalwidth, globalheight) : Container(),
          ],
        ),
      );

  Widget modifybutton(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: GestureDetector(
          onTap: () => setState(() {
            if (mdshow) {
              print('Make change');
              updateEmergencyDetail();
            }
            mdshow = !mdshow;
          }),
          child: Align(
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                height: globalheight * 0.08,
                width: globalwidth * 0.7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 28, 107, 164),
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromARGB(100, 28, 107, 164),
                        spreadRadius: 2),
                  ],
                ),
                child: mdshow
                    ? const Text('~~Click here to save the details~~',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold))
                    : const Text('~~Click here to modify the details~~',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      );

  Widget modifypage(double globalwidth, double globalheight) =>
      DefaultTextStyle.merge(
        child: Container(
          height: globalheight * 0.44,
          width: globalwidth * 0.96,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            boxShadow: [
              BoxShadow(color: Colors.black, spreadRadius: 3),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: globalheight * 0.1,
                    width: globalwidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                hintText: 'Emergency Contact Name:',
                                labelText: 'Emergency Contact Name:',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: globalheight * 0.1,
                    width: globalwidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _contactController,
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                hintText: 'Emergency Contact Phone Number:',
                                labelText: 'Emergency Contact Phone Number:',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: globalheight * 0.1,
                    width: globalwidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _relationController,
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                hintText: 'Emergency Contact Relation:',
                                labelText: 'Emergency Contact Relation:',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    height: globalheight * 0.1,
                    width: globalwidth * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _allergyController,
                              decoration: InputDecoration(
                                fillColor: Colors.red,
                                hintText: 'Allergy Record:',
                                labelText: 'Allergy Record:',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}