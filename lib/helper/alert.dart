import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/yannie_version/color.dart';

showAlertDialog(BuildContext context, String message) {
  // Show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(message),
        titlePadding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
        icon: const Icon(Icons.error_outline, size: 50,),
        iconPadding: const EdgeInsets.symmetric(vertical: 20),
        iconColor: const Color.fromARGB(255, 235, 120, 112),
        titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black, fontSize: 15)),
        shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                content: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(MediaQuery.of(context).size.height*0.08),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30))),
                                                backgroundColor: lighttheme,
                                                 padding: EdgeInsets.symmetric(vertical: 20)
                                                ),
            child: Text('Okay', style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17)),)),
        contentPadding: EdgeInsets.all(0),
      );
    }
  );
}


showSuccessDialog(BuildContext context, String message) {
  // Show the dialog
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
                      Navigator.pop(context);
                     });
      return AlertDialog(
        title: Text(message),
        titlePadding: const EdgeInsets.only(left: 35, right: 35, bottom: 30),
        icon: const Icon(Icons.check_circle_outline, size: 50,),
        iconPadding: const EdgeInsets.symmetric(vertical: 20),
        iconColor: const Color.fromARGB(255, 136, 202, 98),
        titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black, fontSize: 15)),
        shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
      );
    }
  );
}