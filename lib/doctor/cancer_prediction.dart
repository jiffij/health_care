import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../helper/loading_screen.dart';
import '../helper/firebase_helper.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String lesion;
  final double acc;

  ChartData(this.lesion, this.acc);
}

class CancerPredict extends StatefulWidget {
  const CancerPredict({super.key});

  @override
  State<CancerPredict> createState() => _CancerPredictState();
}

class _CancerPredictState extends State<CancerPredict> {
  bool isLoading = true;
  String? category;
  late File _image;
  Image? displayImg;
  Map<String, dynamic>? results;
  String? _patientName;
  String? _woundArea;
  bool waitingForResult = false;

  @override
  void initState() {
    super.initState();
    // _getImg();
    setState(() {
      isLoading = false;
    });
  }

  _getImg() async {
    // return Image.asset('assets/ISIC_0024306.jpg', fit: BoxFit.contain); // TODO

    //current user id
    final userID = FirebaseAuth.instance.currentUser!.uid;

    //collect the image name
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('medical_history')
        .doc(userID)
        .get();

    //a list of images names (i need only one)
    var fileName = variable['upload_img'];

    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        // .child("images/user/profile_images/${_userID}")
        .child(fileName[0]);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      // _imgUrl = url;
      displayImg = Image.network(url);
    });
  }

  String _getName() {
    return 'name from firestore'; //TODO
  }

  String _getCancerLoc() {
    return 'Location from firestore'; //TODO
  }

  pickFromFirestore() async {
    //TODO
  }

  pickFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
      waitingForResult = true;
    });
    print('attempting to connect to server...');
    var respStr = await cancerPredict(_image);
    // var respStr = await cancerPredict(_image);
    setState(() {
      results = respStr;
      displayImg = Image.file(_image);
      waitingForResult = false;
    });
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? LoadingScreen()
      : Scaffold(
          body: Container(
              // color: Colors.blue[700],
              child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Skin Cancer Prediction',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Caution!\nThe predicted result is only for reference. We do not take any responsibility for the result.\nBe patient. It may takes few seconds.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18.0, color: Colors.black),
                  ),
                ),
                ElevatedButton(
                    onPressed: pickFromGallery,
                    child: waitingForResult
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text('Pick from gallery')),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: displayImg),
                if (_patientName != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '''
                      Patient: ${_getName()}
                      Wound location: ${_getCancerLoc()}
                      ''',
                      style: TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.left,
                    ),
                  ),
                // Text(
                //   category != null ? category! : '',
                //   style: TextStyle(fontSize: 18.0, color: Colors.black),
                // ),
                if (results != null)
                  SfCartesianChart(
                    title: ChartTitle(text: 'Likelyhood by Skin Lesion'),
                    legend: Legend(isVisible: true),
                    series: <ChartSeries>[
                      BarSeries<ChartData, String>(
                        name: 'Acc',
                        dataSource: <ChartData>[
                          ChartData('Acti', results?['result'][0] ?? 0),
                          ChartData('Basal', results?['result'][1] ?? 0),
                          ChartData('Benign', results?['result'][2] ?? 0),
                          ChartData('Derm', results?['result'][3] ?? 0),
                          ChartData('Mel_nevi', results?['result'][4] ?? 0),
                          ChartData('Mel', results?['result'][5] ?? 0),
                          ChartData('Vas', results?['result'][6] ?? 0),
                        ],
                        xValueMapper: (ChartData acc, _) => acc.lesion,
                        yValueMapper: (ChartData acc, _) => acc.acc,
                        dataLabelSettings: DataLabelSettings(isVisible: true),
                      ),
                    ],
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Probability'),
                      maximum: 1,
                    ),
                  ),

                // Text(
                //   category != null ? category!.label : '',
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                // ),
                // FloatingActionButton(
                //   onPressed: _getImage,
                //   tooltip: 'Pick Image',
                //   child: Icon(Icons.add_a_photo),
                // ),
              ]),
        )));
}
