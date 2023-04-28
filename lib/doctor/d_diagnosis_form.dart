import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import '../helper/firebase_helper.dart';

class DiagnosticForm extends StatefulWidget {
  String patientName;
  String appointmentDateTime;
  String patientUid;

  DiagnosticForm(this.patientName, this.appointmentDateTime, this.patientUid,
      {super.key});
  @override
  _DiagnosticFormState createState() => _DiagnosticFormState(
      this.patientName, this.appointmentDateTime, this.patientUid);
}

class _DiagnosticFormState extends State<DiagnosticForm> {
  String patientName;
  String appointmentDateTime;
  String patientUid;
  _DiagnosticFormState(this.patientName, this.appointmentDateTime, this.patientUid);

  final _diagnosisController = TextEditingController();
  final _MedController = TextEditingController();
  final _noteController = TextEditingController();

// Initialise a controller. It will contains signature points, stroke width and pen color.
// It will allow you to interact with the widget
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    _diagnosisController.dispose();
    _MedController.dispose();
    _noteController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('My Page'),
      // ),

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
                      'Patient:',
                      style: TextStyle(fontSize: 18),
                    )),
                    Expanded(
                        child: Text(
                      'Date of Birth:',
                      style: TextStyle(fontSize: 18),
                    )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                      patientName,
                      style: TextStyle(fontSize: 16),
                    )),
                    Expanded(
                        child: Text(
                      appointmentDateTime,
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
                  // INITIALIZE. RESULT IS A WIDGET, SO IT CAN BE DIRECTLY USED IN BUILD METHOD
                  Signature(
                    controller: _controller,
                    width: 300,
                    height: 200,
                    backgroundColor: Color.fromARGB(255, 225, 225, 225),
                  ),
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

                        String signId = '';
                        if (_controller.isNotEmpty) {
                          var signature = await _controller.toPngBytes();
                          signId = await uploadImageByte(
                              signature!, 'name', 'description');
                        } else {
                          return;
                        }
                        var uid = getUID();
                        final now = getDateTime();
                        // print('medical_history/$uid/$patientUid/$now');
                        var data = {
                          'doctor': uid,
                          'patient': patientUid,
                          'diagnosis': diagnosis,
                          'medicine': medicine,
                          'extra_notes': notes,
                          'signature_url': signId,
                        };
                        print(data);
                        print(now);
                        // Handle submit button press
                        var res1 = await writeToServer(
                            'doctor/$uid/$patientUid/$appointmentDateTime', data);
                        var res2 = await writeToServer(
                            'patient/$patientUid/history/$appointmentDateTime', data);
                        // var res2 =
                        //     await writeToServer('medical_history/$now', data);

                        if (res1.statusCode != 200 || res2.statusCode != 200) {
                          print('history upload error');
                        }
                      },
                      child: Text('Publish'),
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
