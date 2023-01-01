import 'package:flutter/material.dart';

class CancerPredict extends StatefulWidget {
  const CancerPredict({super.key});

  @override
  State<CancerPredict> createState() => _CancerPredictState();
}

class _CancerPredictState extends State<CancerPredict> {
  Image _getImg() {
    return Image.asset('assets/ISIC_0024306.jpg', fit: BoxFit.contain); // TODO
  }

  String _getName() {
    return 'name from firestore'; //TODO
  }

  String _getCancerLoc() {
    return 'Location from firestore'; //TODO
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
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Skin Cancer Prediction',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 25.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: width * 0.8,
                      height: height * 0.4,
                      child:
                        _getImg()
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                      '''
                      Patient: ${_getName()}
                      Wound location: ${_getCancerLoc()}
                      Result:
                      ''',
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ]),
            )));
  }
}
