import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/yannie_version/pages/yannie_myBooking.dart';

import '../color.dart';


class UpcomingAppointmentCard extends StatefulWidget {

  @override
  State<UpcomingAppointmentCard> createState() => _UpcomingAppointmentCardState();

  const UpcomingAppointmentCard({
    Key? key,
    required this.appointment,
  }) : super(key: key);
  final List appointment;

}

class _UpcomingAppointmentCardState extends State<UpcomingAppointmentCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: defaultHorPadding/2),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        splashFactory: InkRipple.splashFactory,
        splashColor: Colors.white.withOpacity(0.3),
        child: Ink(
          padding: const EdgeInsets.only(
            left: defaultHorPadding/2,
            right: defaultHorPadding/2,
          ),
          width: size.width * 0.7,
          height: size.height * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: lighttheme,
            boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                      color: goodColor.withOpacity(0.13),
                    ),
                  ],
          ),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              String bookingTime = timeFormatter(widget.appointment[1]);
              String bookingDate = dateFormatter(widget.appointment[0]);
              double parentWidth = constraints.maxWidth;
              double parentHeight = constraints.maxHeight;
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 1,
                heightFactor: 0.75,
                child: Row(children: [
                    Container(
                      width: parentWidth*0.35,
                      height: parentHeight,
                      margin: EdgeInsets.only(left: parentWidth*0.05),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white
                      ),
                      child: Text(bookingDate, style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 18, height: 1.5, fontWeight: FontWeight.w700)), textAlign: TextAlign.center,),
                  ),
                  Container(
                      width: parentWidth*0.6,
                      height: parentHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: parentWidth*0, vertical: parentHeight*0.05), child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          
                          Text(bookingTime, style: card, textAlign: TextAlign.left,),
                          Flexible(
                            child: Text(
                              'Dr. ${widget.appointment[2]}',
                              style: card2,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Speciality',
                              style: card,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                      ]))
                  ),
                ])
              );
            },
          ),
        ),
      ),
    );
  }
}

String timeFormatter(String time) {
  String hour = time.substring(0, 2);
  int hourInInt = int.parse(hour);

  if (hourInInt>12){
    hourInInt -= 12;
    String result = hourInInt.toString() + time.substring(2) + " PM";
    return result;
  }
  
  return time + " AM";
}

String dateFormatter(String date) {
  String day = date.substring(6);
  String month = date.substring(4, 6);
  switch (month) {
    case "01": 
      month = "Jan";
      break;
    case "02": 
      month = "Feb";
      break;
      case "03": 
      month = "Mar";
      break;
      case "04": 
      month = "Apr";
      break;
      case "05": 
      month = "May";
      break;
      case "06": 
      month = "Jun";
      break;
      case "07": 
      month = "Jul";
      break;
      case "08": 
      month = "Aug";
      break;
      case "09": 
      month = "Sep";
      break;
      case "10": 
      month = "Oct";
      break;
      case "11": 
      month = "Nov";
      break;
      case "12": 
      month = "Dec";
      break;
  }
  return day + "\n" + month;
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
