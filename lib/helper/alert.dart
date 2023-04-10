import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

showAlertDialog(BuildContext context, String message) {
  AlertDialog dialog = AlertDialog(
    title: Text(message),
    titlePadding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
    icon: const Icon(Icons.error_outline, size: 50,),
    iconPadding: const EdgeInsets.symmetric(vertical: 20),
    iconColor: const Color.fromARGB(255, 235, 120, 112),
    titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black, fontSize: 15), height: 1.5),
    shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context,);
        },
        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                                            backgroundColor: Color.fromARGB(255, 47, 106, 173),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 140, vertical: 17),
                                                minimumSize: const Size.fromHeight(50),
                                            ),
        child: Text('OK', style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),))
    ],
    actionsAlignment: MainAxisAlignment.center,
    actionsPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
  );

  // Show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return dialog;
    }
  );
}