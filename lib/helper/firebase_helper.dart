import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';

enum ID { PATIENT, DOCTOR, ADMIN, NOBODY }

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
  var doc = await getDoc(id + uid);
  return doc?['isValid'];
}

/*
Example
  final String uid = await getUID();
  print(await checkDocExist("patient/$uid"));
*/
Future<bool> checkDocExist(String docID) async {
  bool exist = false;
  try {
    await FirebaseFirestore.instance.doc(docID).get().then((doc) {
      //"users/$docID"
      exist = doc.exists;
    });
    return exist;
  } catch (e) {
    // If any error
    return false;
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
