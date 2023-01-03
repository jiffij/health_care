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
// import 'package:firebase_core/firebase_core.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

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

  late List _outputs;
  late File _image;
  String? _imgUrl;

  @override
  void initState() {
    super.initState();
    _getImg();
    loadModel().then((value) {
      setState(() {});
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
      _imgUrl = url;
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
                        child: Image.network(_imgUrl.toString())),
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

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        '''
                      Result:
                      ''',
                        style: TextStyle(fontSize: 18.0),
                        textAlign: TextAlign.left,
                      ),
                    ),

                    ElevatedButton(
                        onPressed: pickImage, child: Text('Predict')),

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
}
