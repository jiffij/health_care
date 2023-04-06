import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import 'encryption.dart';
import 'dart:io';

// import 'dart:convert' show utf8;

enum ID { PATIENT, DOCTOR, ADMIN, NOBODY }

const URL = 'http://143.89.130.155:8080';
//return the UID of the user
String getUID() {
  return auth.currentUser!.uid;
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
  final bool exist = await checkDocExist(docID);
  var dir = exist ? 'add' : 'set';
  var server_key = await getServerPublicKey();
  // print(server_key);
  var new_body = await rsaEncrypt(jsonEncode(body), server_key);
  // print(new_body);
  return http.post(
    Uri.parse('$URL/$dir'),
    headers: <String, String>{
      'Content-Type': 'text/plain', // 'application/json; charset=UTF-8',
      'path': docID,
    },
    body: new_body,
  );
}

Future<Map<String, dynamic>?> readFromServer(String docID) async {
  var public_key = await getMyPublicKey();
  var response = await http.post(
    Uri.parse('$URL/list'),
    headers: <String, String>{
      'Content-Type': 'text/plain', // 'application/json; charset=UTF-8',
      'path': docID,
    },
    body: public_key,
  );
  print('status code:$response.statusCode');
  if (response.statusCode == 204) return null;
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