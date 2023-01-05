import 'package:flutter/material.dart';
import 'package:simple_login/cancer_model.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:simple_login/classifier.dart';
import 'package:logger/logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'package:simple_login/flutter_tflite-master/lib/tflite.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_login/loading_screen.dart';
import 'package:fl_chart/fl_chart.dart';

// class _ChartData {
//   _ChartData(this.x, this.y);

//   final String x;
//   final double y;
// }

class _BarChart extends StatelessWidget {
  const _BarChart();

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: titlesData,
        borderData: borderData,
        barGroups: barGroups,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Acti';
        break;
      case 1:
        text = 'Basal';
        break;
      case 2:
        text = 'Benign';
        break;
      case 3:
        text = 'Derm';
        break;
      case 4:
        text = 'Mel_nevi';
        break;
      case 5:
        text = 'Mel';
        break;
      case 6:
        text = 'Vas';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.lightBlueAccent,
          Colors.greenAccent,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 8,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 14,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: 15,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: 13,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: 10,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
              toY: 16,
              gradient: _barsGradient,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}



class CancerPredict extends StatefulWidget {
  const CancerPredict({super.key});

  @override
  State<CancerPredict> createState() => _CancerPredictState();
}

class _CancerPredictState extends State<CancerPredict> {
  // late Classifier _classifier;

  // var logger = Logger();

  // File? _image;
  // final picker = ImagePicker();

  // Image? _imageWidget;

  // img.Image? fox;

  // Category? category;

  // @override
  // void initState() {
  //   super.initState();
  //   _classifier = cancerClassifier();
  // }

  // Future _getImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     _image = File(pickedFile!.path);
  //     _imageWidget = Image.file(_image!);

  //     _predict();
  //   });
  // }
  bool isLoading = true;

  late List _outputs;
  late File _image;
  // String? _imgUrl;
  Image? displayImg;
  // late List<_ChartData> data;

  @override
  void initState() {
    super.initState();
    _getImg();
    loadModel().then((value) {
      setState(() {
        isLoading = false;
        // data = [_ChartData('a', 10)];
      });
    });
  }

  pickImage() async {
    try {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return null;
      setState(() {
        _image = File(image.path);
      });
      classifyImage(_image);
    } catch (e) {
      print(e);
    }
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
    );
    print("predict = " + output.toString());
    setState(() {
      _outputs = output!;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/My_TFlite_Model.tflite",
      labels: "assets/label.txt",
    );
    print("load model success!");
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
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

  // void _predict() async {
  //   img.Image imageInput = img.decodeImage(_image!.readAsBytesSync())!;
  //   var pred = _classifier.predict(imageInput);

  //   setState(() {
  //     this.category = pred;
  //   });
  // }

  @override
  Widget build(BuildContext context) => isLoading
      ? LoadingScreen()
      : Scaffold(
          body: Container(
            color: Colors.blue[700],
              child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Skin Cancer Prediction',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: displayImg),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    
                    '''
                      Patient: ${_getName()}
                      Wound location: ${_getCancerLoc()}
                      Result:
                      ''',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
                AspectRatio(
                  aspectRatio: 1.7,
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    color: const Color(0xff2c4260),
                    child: const _BarChart(),
                  ),
                ),
                ElevatedButton(onPressed: pickImage, child: Text('Predict')),

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
