import 'dart:io';

import 'package:flutter/material.dart';
import '../helper/firebase_helper.dart';

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
    // Map<String, String>? stringMap =
    //     predResult?.map((key, value) => MapEntry(key, value.toString()));

    int maxIndex = -1;
    double maxValue = double.negativeInfinity;

    predResult?.forEach((key, value) {
      List<double> doubleList = List.castFrom<dynamic, double>(value);
      doubleList.forEach((doubleValue) {
        if (doubleValue > maxValue) {
          maxValue = doubleValue;
          maxIndex = doubleList.indexOf(doubleValue);
        }
      });
    });

    cancerType = maxIndex.toString();
    percentage = maxValue.toString();
    print(cancerType);
    print(percentage);
    // String res0 = (predResult?['result'][0] ?? 0).toString();
    // String res1 = (predResult?['result'][1] ?? 0).toString();
    // String res2 = (predResult?['result'][2] ?? 0).toString();
    // String res3 = (predResult?['result'][3] ?? 0).toString();
    // String res4 = (predResult?['result'][4] ?? 0).toString();
    // String res5 = (predResult?['result'][5] ?? 0).toString();
    // String res6 = (predResult?['result'][6] ?? 0).toString();
    // String res7 = (predResult?['result'][7] ?? 0).toString();
    // Map<String, String> stringMap = {
    //   '0': res0,
    //   '1': res1,
    //   '2': res2,
    //   '3': res3,
    //   '4': res4,
    //   '5': res5,
    //   '6': res6,
    //   '7': res7,
    // };
    // if (predResult == null) return null;
    // print(stringMap);
    // return stringMap;
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      'Appointment date:',
                      style: TextStyle(fontSize: 18),
                    )),
                    Expanded(
                        child: Text(
                      'Appointment time:',
                      style: TextStyle(fontSize: 18),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      appointDate,
                      style: TextStyle(fontSize: 16),
                    )),
                    Expanded(
                        child: Text(
                      appointTime,
                      style: TextStyle(fontSize: 16),
                    )),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: _diagnosisController,
                    decoration: InputDecoration(
                      hintText: 'Diagnosis',
                    ),
                  ),
                  TextField(
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    controller: _MedController,
                    decoration: InputDecoration(
                      hintText: 'Medication',
                    ),
                  ),
                  TextField(
                    controller: _noteController,
                    decoration: InputDecoration(
                      hintText: 'Extra notes',
                    ),
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                  ),
                  SizedBox(
                    height: 20,
                  ),
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
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.file(imgFile!)),
                  // INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
                  Spacer(),
                  Container(
                    alignment: Alignment.centerRight,
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
                        if (imgFile != null) {
                          await predict();
                        }
                        // final now = getDateTime();
                        // print('medical_history/$uid/$appointTime/$now');
                        var data = {
                          appointTime: {
                            'diagnosis': diagnosis,
                            'medicine': medicine,
                            'extra_notes': notes,
                            if(cancerType != '') 'prediction': cancerType,
                            if(percentage != '') 'probability': percentage,
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
                        // var res1 = await writeToServer(
                        //     'doctor/$uid/$appointTime/$now', data);
                        var res2 = await writeToServer(
                            'patient/$uid/survey/$appointDate', data);
                        if (res2.statusCode != 200) {
                          print('history upload error');
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
