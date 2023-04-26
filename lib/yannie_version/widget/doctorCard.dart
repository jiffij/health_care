
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../color.dart';
import '../doctor.dart';
import '../pages/yannie_doctor_info.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required List this.doctor,
  }) : super(key: key);

  final List doctor;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/4, horizontal: 0),
      // child: DecoratedBox(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(30),
      //       color: Colors.white.withOpacity(0.9),
      //       boxShadow: [
      //               BoxShadow(
      //                 offset: const Offset(0, 8),
      //                 blurRadius: 5,
      //                 color: goodColor.withOpacity(0.13),
      //               ),
      //             ],
      //   ),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          elevation: 4,
          shadowColor: bgColor,
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
        onTap: () {
          Navigator.of(context).push(_createRoute(DoctorDetailScreen(doctor: doctor)));
        },
        borderRadius: BorderRadius.circular(20),
        splashFactory: InkRipple.splashFactory,
        splashColor: lighttheme.withOpacity(0.1),
        child: Ink(
          decoration: BoxDecoration(
            //border: Border.all(color: themeColor),
          borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            // boxShadow: [
            //         BoxShadow(
            //           offset: const Offset(0, 8),
            //           blurRadius: 5,
            //           color: goodColor.withOpacity(0.13),
            //         ),
            //       ],
        ),
          padding: const EdgeInsets.symmetric(
            horizontal: defaultHorPadding/2,
            vertical: defaultHorPadding/2,
          ),
          width: size.width * 0.7,
          height: size.height * 0.15,
          child: Row(
        children: [
          Container(
            width: size.width* 0.26,
            decoration: BoxDecoration(
              color: lighttheme.withOpacity(0.3),
              //border: Border.all(color: themeColor),
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
              image: NetworkImage(doctor[2]),
              fit: BoxFit.cover,
            ),
            ),
            ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Dr. ${doctor[0]}',
                style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 17, color: themeColor, fontWeight: FontWeight.w500)),
              ),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'doctor.doctorSpecialty',
                    style: GoogleFonts.comfortaa(textStyle: TextStyle(
                        fontSize: 14,
                        color: themeColor)),
                    maxLines: 1,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '⭐ ${doctor[4]} / 5.0',
                    style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xff91919F),
                        fontWeight: FontWeight.normal),
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
        ),
      ))
      //)
      
    );
  }
}

Route _createRoute(Widget destinition) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => destinition,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}