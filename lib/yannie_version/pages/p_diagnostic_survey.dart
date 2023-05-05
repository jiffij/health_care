import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../helper/alert.dart';
import '../../helper/firebase_helper.dart';
import '../color.dart';

class DiagnosticSurvey extends StatefulWidget {
  String docId;
  String appointDate;
  String appointTime;

  DiagnosticSurvey(this.docId, this.appointDate, this.appointTime, {super.key});
  @override
  _DiagnosticSurveyState createState() =>
      _DiagnosticSurveyState(this.docId, this.appointDate, this.appointTime);
}

class _DiagnosticSurveyState extends State<DiagnosticSurvey> {
  String docId;
  String appointDate;
  String appointTime;
  File? imgFile;
  String cancerType = '';
  String percentage = '';
  Map? stringMap;

  _DiagnosticSurveyState(this.docId, this.appointDate, this.appointTime);

  final _diagnosisController = TextEditingController();
  final _MedController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _diagnosisController.dispose();
    _MedController.dispose();
    _noteController.dispose();
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

  Future<void> predict() async {
    var predResult = await cancerPredict(imgFile!);
    if (predResult == null) return;
    // Map<String, String>? stringMap =
    //     predResult?.map((key, value) => MapEntry(key, value.toString()));

    // int maxIndex = -1;
    // double maxValue = double.negativeInfinity;
    //
    // predResult?.forEach((key, value) {
    //   List<double> doubleList = List.castFrom<dynamic, double>(value);
    //   doubleList.forEach((doubleValue) {
    //     if (doubleValue > maxValue) {
    //       maxValue = doubleValue;
    //       maxIndex = doubleList.indexOf(doubleValue);
    //     }
    //   });
    // });
    //
    // cancerType = maxIndex.toString();
    // percentage = maxValue.toString();
    // print(cancerType);
    // print(percentage);

    String res0 = (predResult?['result'][0] ?? 0).toString();
    String res1 = (predResult?['result'][1] ?? 0).toString();
    String res2 = (predResult?['result'][2] ?? 0).toString();
    String res3 = (predResult?['result'][3] ?? 0).toString();
    String res4 = (predResult?['result'][4] ?? 0).toString();
    String res5 = (predResult?['result'][5] ?? 0).toString();
    String res6 = (predResult?['result'][6] ?? 0).toString();
    String res7 = (predResult?['result'][7] ?? 0).toString();
    stringMap = {
      '0': res0,
      '1': res1,
      '2': res2,
      '3': res3,
      '4': res4,
      '5': res5,
      '6': res6,
      '7': res7,
    };

    // print(stringMap);
    // return stringMap;
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: (){FocusScope.of(context).requestFocus(FocusNode());},
      child: Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
                  //title: Text('Search For Doctor'),
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  toolbarHeight: 80,
                  backgroundColor: lighttheme,
                  titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500)),
                  centerTitle: true,
                  title: Text('Symptom Survey'),),
                  
      body: 
                        SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Flexible(child: SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                child: Container(
                                  padding: EdgeInsets.all(defaultHorPadding),
                                  child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(vertical: defaultHorPadding, horizontal: defaultHorPadding*1.5),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 8),
                                            blurRadius: 5,
                                            color: goodColor.withOpacity(0.13),
                                          ),
                                        ]
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_month_rounded,
                                                color: lighttheme,
                                                size: 23,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                DateFormat("d MMMM y").format(toDateTime(appointDate, appointTime)),
                                                style: GoogleFonts.comfortaa(
                                                    color: lighttheme, fontSize: 16),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.schedule_rounded,
                                                color: lighttheme,
                                                size: 23,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                DateFormat("HH:mm").format(toDateTime(appointDate, appointTime)),
                                                style: GoogleFonts.comfortaa(
                                                    color: lighttheme, fontSize: 16),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: defaultVerPadding),
                                      padding: EdgeInsets.symmetric(vertical: defaultHorPadding, horizontal: defaultHorPadding),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.5),
                                        borderRadius: BorderRadius.all(Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 8),
                                            blurRadius: 5,
                                            color: goodColor.withOpacity(0.13),
                                          ),
                                        ]
                                      ),
                                      child: Column(children: [
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 20),
                                          child: TextFormField(
                                            controller: _diagnosisController,
                                            maxLines: 5,
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
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Symtoms",
                                              //hintText: 'Write down your symptoms',
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
                                            controller: _MedController,
                                            maxLines: 5,
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
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Mediacation",
                                              //hintText: 'Write down your symptoms',
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
                                            controller: _noteController,
                                            maxLines: 5,
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
                                              filled: true,
                                              fillColor: Colors.white,
                                              labelText: "Extra Notes",
                                              //hintText: 'Write down your notes.',
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
                                        InkWell(
                                      onTap: () async {
                                        String? option =
                                            await showOptionDialog(context);
                                        await getImg(option!);
                                      },
                                      splashColor: lighttheme.withOpacity(0.1),
                                      borderRadius:
                                                BorderRadius.circular(20),
                                      child: Container(
                                        alignment: Alignment.center,
                                        // width: MediaQuery.of(context).size.width *
                                        //     0.3,
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        // margin: EdgeInsets.only(
                                        //     bottom: defaultHorPadding,
                                        //     top: defaultHorPadding / 2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            //border: Border.all(color: themeColor),
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                      Container(
                                        //height: 100,
                                        width: double.infinity,
                                        color: Colors.transparent,
                                        margin: EdgeInsets.only(top: defaultVerPadding),
                                        //padding: EdgeInsets.symmetric(vertical: defaultVerPadding),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final diagnosis = _diagnosisController.text;
                                          final medicine = _MedController.text;
                                          final notes = _noteController.text;

                                          if (diagnosis.isEmpty ||
                                              medicine.isEmpty ||
                                              notes.isEmpty) {
                                            return;
                                          }

                                          var uid = getUID();
                                          // Map<String, String>? result;
                                          String? imgURL;
                                          if (imgFile != null) {
                                            await predict();
                                            imgURL = await uploadImage(imgFile!, "", "skin");
                                          }

                                          // final now = getDateTime();
                                          // print('medical_history/$uid/$appointTime/$now');
                                          var data = {
                                            appointTime: {
                                              'diagnosis': diagnosis,
                                              'medicine': medicine,
                                              'extra_notes': notes,
                                              if(stringMap != null) 'prediction': stringMap,
                                              if(imgURL != null) "imgURL": imgURL,
                                              // if(cancerType != '') 'prediction': cancerType,
                                              // if(percentage != '') 'probability': percentage,

                                              // if (result != null)
                                              //   'a': result['0'],
                                              //   if (result != null)
                                              //   'b': result['1'],
                                              //   if (result != null)
                                              //   'c': result['2'],
                                              //   if (result != null)
                                              //   'd': result['3'],
                                              //   if (result != null)
                                              //   'e': result['4'],
                                              //   if (result != null)
                                              //   'f': result['5'],
                                              //   if (result != null)
                                              //   'g': result['6'],
                                              //   if (result != null)
                                              //   'h': result['7'],
                                            }
                                          };
                                          print(data);
                                          // Handle submit button press
                                          var res1 = await writeToServer(
                                              'doctor/$docId/appointment/$appointDate/survey/$appointTime', data);
                                          var res2 = await writeToServer(
                                              'patient/$uid/appointment/$appointDate/survey/$appointTime', data);
                                          if (res2.statusCode != 200 || res2.statusCode != 200) {
                                            print('history upload error');
                                          } else {
                                            Navigator.of(context).pop();
                                          }
                                        }, 
                                        style: ButtonStyle(
                                          padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: defaultVerPadding/1.5)),
                                          backgroundColor: MaterialStatePropertyAll(lighttheme),
                                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))))
                                        ),
                                        child: Text("Submit", style: GoogleFonts.comfortaa(fontSize: 18),),),
                                      )
                                      ]),
                                    ),
                                    
                                    
                                  ],
                                ),)
                        )),
                  ],
                ),
              )));
  }
}
 DateTime toDateTime(String date, String time) {
  int year = int.parse(date.substring(0, 4));
  int month = int.parse(date.substring(4, 6));
  int day = int.parse(date.substring(6));
  int hour = int.parse(time.substring(0, 2));
  int min = int.parse(time.substring(3, 5));
  return DateTime(year, month, day, hour, min);
}
