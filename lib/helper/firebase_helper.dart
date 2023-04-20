import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import '../main.dart';
import 'encryption.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'dart:math';
// import 'dart:convert' show utf8;

enum ID { PATIENT, DOCTOR, ADMIN, NOBODY }

final int MAX_TRIES = 20;
const URL = 'http://143.89.130.155:8080';
// const URL = 'http://192.168.0.178:5000';

// FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;

bool checkSignedin() {
  if (auth.currentUser != null) {
    return true;
  } else {
    return false;
  }
}

//return the UID of the user
String getUID() {
  return auth.currentUser!.uid;
}

bool checkEmailAuth() {
  return auth.currentUser!.emailVerified;
}

String getDateTime() {
  final now = DateTime.now();
  final formatted = DateFormat('yyyyMMddkkmm').format(now);
  return formatted.toString();
}

//Get the identity of the user
Future<ID> patientOrdoc() async {
  var uid = getUID();
  if (await checkDocExist('patient/$uid')) {
    return ID.PATIENT;
  } else if (await checkDocExist('doctor/$uid')) {
    return ID.DOCTOR;
  } else {
    return ID.NOBODY;
  }
}

Future<String> patientOrdocStr() async {
  var id = await patientOrdoc();
  String pos;
  switch (id) {
    case ID.DOCTOR:
      pos = 'doctor';
      break;
    case ID.PATIENT:
      pos = 'patient';
      break;
    case ID.NOBODY:
      pos = '';
      break;
    default:
      pos = '';
  }
  return pos;
}

Future<bool> isValid() async {
  var uid = getUID();
  String id;
  switch (await patientOrdoc()) {
    case ID.DOCTOR:
      id = 'doctor/';
      break;
    case ID.PATIENT:
      id = 'patient/';
      break;
    case ID.ADMIN:
    case ID.NOBODY:
      return false;
  }
  var doc = await readFromServer(id + uid);
  return doc?['isValid'];
}

/*
Example
  final String uid = await getUID();
  print(await checkDocExist("patient/$uid"));
*/
Future<bool> checkDocExist(String docID) async {
  if (await readFromServer(docID) == null) {
    return false;
  } else {
    return true;
  }
}

/*
Set the data in Document
 Example
  setDoc("doctor/$uid", {
    'first name': _nameController.text,
    'last name': _lastnameController.text,
    'email': auth.currentUser!.email,
    'HKID': _idController.text
  });
 */
Future<void> setDoc(String docID, Map<String, dynamic> map) async {
  // final String uid = await getUID();
  final bool exist = await checkDocExist(docID);
  return FirebaseFirestore.instance
      .doc(docID)
      .set(map, SetOptions(merge: true))
      .then((value) => print("Document set!"))
      .catchError((error) => print("Failed to add user: $error"));
}

/* 
get all data in a document
e.g.
    var data = await getDoc("doctor/$uid");
    print(await data?['first name']);
    print(await data?['last name']);
*/
Future<Map<String, dynamic>?> getDoc(String docID) async {
  var docSnapshot = await FirebaseFirestore.instance.doc(docID).get();

  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    return data;
  }
  return null;
}

// Update the information in Firebase auth
void updateAuthInfo(String name) async {
  if (auth.currentUser != null) {
    await auth.currentUser?.updateDisplayName(name);
  }
}

Future<String> getServerPublicKey() async {
  var response = await http.get(
    Uri.parse('$URL/publickey'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response.body;
}

Future<http.Response> writeToServer(
    String docID, Map<String, dynamic> body) async {
  http.Response res;
  // int count = 0;
  // do {
  //   if(count > 0){
  //     await generateKey();
  //   }

  final bool exist = await checkDocExist(docID);
  var dir = exist ? 'add' : 'set';
  var server_key = await getServerPublicKey();
  // print(server_key);
  var new_body = await rsaEncrypt(jsonEncode(body), server_key);
  // print(new_body);

  res = await http.post(
    Uri.parse('$URL/$dir'),
    headers: <String, String>{
      'Content-Type': 'text/plain', // 'application/json; charset=UTF-8',
      'path': docID,
    },
    body: new_body,
  );
  // count++;
  // } while (!(await checkDocExist(docID)) && count < MAX_TRIES);
  return res;
}

Future<Map<String, dynamic>?> readFromServer(String docID) async {
  http.Response response;
  // int count = 0;
  // do {
  //   if (count > 0){
  //     await generateKey();
  //   }

  var public_key = await getMyPublicKey();
  response = await http.post(
    Uri.parse('$URL/list'),
    headers: <String, String>{
      'Content-Type': 'text/plain', // 'application/json; charset=UTF-8',
      'path': docID,
    },
    body: public_key,
  );
  //   count++;
  // } while (response.statusCode == 204 && count < MAX_TRIES);

  print(response.body);
  print('status code:$response.statusCode');
  if (response.statusCode == 204) return null;
  print(jsonDecode(await rsaDecrypt(response.body)));
  return jsonDecode(await rsaDecrypt(response.body));
  // return jsonDecode(response.body);
}

Future<Map<String, dynamic>?> cancerPredict(File img) async {
  var request = http.MultipartRequest('POST', Uri.parse('$URL/predict'));
  request.files.add(http.MultipartFile.fromBytes('file', img.readAsBytesSync(),
      filename: img.path));
  var response = await request.send();
  var respStr = await response.stream.bytesToString();
  if (respStr == "None") return null;
  return jsonDecode(respStr);
}

Future<Map<String, dynamic>?> cancerPredictEncrypted(File img) async {
  //TODO
  var encode = img.readAsBytesSync();
  var server_key = await getServerPublicKey();
  encode = await rsaEncryptByte(encode, server_key);
  var response = await http.post(
    Uri.parse('$URL/predictEncrypt'),
    headers: <String, String>{
      'Content-Type':
          'application/octet-stream', // 'application/json; charset=UTF-8',
    },
    body: encode,
  );
  // return jsonDecode(await rsaDecrypt(response.body));
}

/// if inputSource == 'camera', it will open camera and take picture\
/// if inputSource == 'gallery', it will open gallery\
/// return a Future<File?>  \
/// Container(  \
///                    width: MediaQuery.of(context).size.width * 0.8,  \
///                    height: MediaQuery.of(context).size.height * 0.4, \
///                    child: Image.file(imgFile!)),
Future<File?> pickImage(String inputSource) async {
  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920);

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);
    return imageFile;
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
  return null;
}

///It checks if the file name exist in firebase storage
Future<bool> checkStorageExists(String fileName) async {
  Reference reference = FirebaseStorage.instance.ref(fileName);
  try {
    await reference.getDownloadURL();
    // File exists
    return true;
  } catch (e) {
    // File does not exist
    return false;
  }
}

///just upload
///It will return the fileName(which is the url) of the Image
///please store the returned String into firestore database
Future<String> uploadImage(File img, String name, String description) async {
  // final String fileName = path.basename(img.path);
  var uid = getUID();
  String fileName;
  do {
    var salt = Random().nextInt(10000000).toString();
    fileName = '$uid$salt';
  } while (await checkStorageExists(fileName));

  try {
    // Uploading the selected image with some custom meta data
    TaskSnapshot taskSnapshot = await storage
        .ref(fileName)
        .putFile(
            img,
            SettableMetadata(customMetadata: {
              'uploaded_by': name,
              'description': description
            }))
        .whenComplete(() => null);

    // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return fileName; //gs://hola-85371.appspot.com/
    // Refresh the UI
  } on FirebaseException catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }

  return '';
}

///just upload
///It will return the fileName(which is the url) of the Image
///please store the returned String into firestore database
Future<String> uploadImageByte(
    Uint8List img, String name, String description) async {
  // final String fileName = path.basename(img.path);
  var uid = getUID();
  String fileName;
  do {
    var salt = Random().nextInt(10000000).toString();
    fileName = '$uid$salt';
  } while (await checkStorageExists(fileName));

  try {
    // Uploading the selected image with some custom meta data
    TaskSnapshot taskSnapshot = await storage
        .ref(fileName)
        .putData(
            img,
            SettableMetadata(customMetadata: {
              'uploaded_by': name,
              'description': description
            }))
        .whenComplete(() => null);

    // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return fileName; //gs://hola-85371.appspot.com/
    // Refresh the UI
  } on FirebaseException catch (error) {
    if (kDebugMode) {
      print(error);
    }
  }

  return '';
}

///pick and upload
Future<String> pickUploadImage(
    String inputSource, String name, String description) async {
  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920);

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);

    try {
      // Uploading the selected image with some custom meta data
      TaskSnapshot taskSnapshot = await storage
          .ref(fileName)
          .putFile(
              imageFile,
              SettableMetadata(customMetadata: {
                'uploaded_by': name,
                'description': description
              }))
          .whenComplete(() => null);
      // String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return fileName;
      // Refresh the UI
    } on FirebaseException catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  } catch (err) {
    if (kDebugMode) {
      print(err);
    }
  }
  return '';
}

/// loadStorageUrl('')\
/// display it with:\
/// String url = await loadStorageUrl('fileName');\
/// Image.network(url);\
/// It will return '' if the image doesn't exits
Future<String> loadStorageUrl(String fileName) async {
  String url;
  if (await checkStorageExists(fileName)) {
    url = await storage.ref(fileName).getDownloadURL();
  } else {
    url = '';
  }
  return url;
}

Future<List<String>> getColId(String path) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference collectionRef = firestore.collection(path);
  QuerySnapshot querySnapshot = await collectionRef.get();
  List<String> documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
  return documentNames;
}

String calRating(
    String one, String two, String three, String four, String five) {
  double sum = int.parse(one) * 1 +
      int.parse(two) * 2 +
      int.parse(three) * 3 +
      int.parse(four) * 4 +
      int.parse(five) * 5;
  int count = int.parse(one) +
      int.parse(two) +
      int.parse(three) +
      int.parse(four) +
      int.parse(five);
  sum /= count;
  if (count == 0) return '0';
  return sum.toStringAsFixed(2);
}
