import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_login/helper/alert.dart';
import 'package:simple_login/patient/p_make_appointment.dart';
import 'package:simple_login/yannie_version/pages/yannie_makeAppointment.dart';

import '../color.dart';
import '../doctor.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen(
    {
      Key? key,
      required List this.doctor
    }) : super(key: key);
    @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();

  final List doctor;
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)?.settings.arguments as Doctor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: lighttheme,
      appBar: AppBar(
                  //title: Text('Search For Doctor'),
                  elevation: 0,
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500)),
                  centerTitle: true,
                  title: Text('Dotor Detalis'),
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
                  leading: Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
                    child: ElevatedButton(
                    style: ButtonStyle(
                      //minimumSize: MaterialStatePropertyAll(Size(60, 60)),
                      elevation: MaterialStatePropertyAll(1),
                      shadowColor: MaterialStatePropertyAll(themeColor),
                      side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                          color: themeColor,
                        )),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                    ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Icon(Icons.arrow_back, size: 23,color: themeColor,)
                    )),
                  leadingWidth: 95,
                  actions: [
                    Padding(
                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
                    child: ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStatePropertyAll(Size(55,55)),
                      elevation: MaterialStatePropertyAll(1),
                      shadowColor: MaterialStatePropertyAll(themeColor),
                      side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                          color: themeColor,
                        )),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                    ),
                      onPressed: () {
                        setState((){isBookmarked = !isBookmarked;}); // TODO: add/remove doctor from bookmark
                      },
                      child: Icon(isBookmarked? Icons.bookmark: Icons.bookmark_border, size: 23,color: themeColor,)
                    )),
                  ],
                ),
      body: SafeArea(
        child: Stack(
          children: [
            
            Column(
              children: [
                Container(
                  color: lighttheme,
                  height: size.height*0.21,
                  //child: Align(
                    //alignment: Alignment.topCenter,
                    //child: 
                    //),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: lighttheme),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(1, 0),
                          blurRadius: 100,
                          color: goodColor.withOpacity(0.13),
                        )
                      ],
                    ),
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        double parentHeight = constraints.maxHeight;
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: defaultHorPadding/2, right: defaultHorPadding/2, top: defaultVerPadding*2.5, bottom: defaultVerPadding/2),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: parentHeight*0.69
                              ),
                              child: RawScrollbar(
                                thumbColor: themeColor.withOpacity(0.5),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: defaultHorPadding/2),
                                child: Column(
                                children: [
                                  //info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left:0 , right:5, bottom: 35),
                                        padding: EdgeInsets.all(20),
                                        height: parentHeight*0.2,
                                        width: parentHeight*0.2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(40)),
                                          border: Border.all(color: lighttheme)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('Patient', style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 14),),
                                            Text('4k', style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left:0 , right:5, bottom: 35),
                                        padding: EdgeInsets.all(20),
                                        height: parentHeight*0.2,
                                        width: parentHeight*0.2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(40)),
                                          border: Border.all(color: lighttheme)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('Exp', style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 14),),
                                            Text('19 yrs', style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left:0 , right:5, bottom: 35),
                                        padding: EdgeInsets.all(20),
                                        height: parentHeight*0.2,
                                        width: parentHeight*0.2,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(40)),
                                          border: Border.all(color: lighttheme)
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text('Rating', style: GoogleFonts.comfortaa(color: lighttheme, fontSize: 14),),
                                            Text('${widget.doctor[4]}', style: GoogleFonts.comfortaa(color: Colors.black, fontSize: 20)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Gender
                                  Row(
                                    children: [
                                      Text(
                                        "Gender",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                      ),
                                      SizedBox(width: size.width*0.2,),
                                      Text(
                                        'doctorGender',
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                      )
                                    ]
                                  ),
                                  //Divider
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                    child: Divider(
                                      color: Color.fromARGB(255, 206, 211, 211),
                                      indent: 0,
                                      endIndent: 0,
                                      height: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Specialty",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                      ),
                                      SizedBox(width: size.width*0.16,),
                                      Text(
                                        'doctorSpecialty',
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                      )
                                    ]
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      child: Divider(
                                        color: Color.fromARGB(255, 206, 211, 211),
                                        indent: 0,
                                        endIndent: 0,
                                        height: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Experience",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                      ),
                                      SizedBox(width: size.width*0.13,),
                                      Text(
                                        '${widget.doctor[5]}',
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                      )
                                    ]
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      child: Divider(
                                        color: Color.fromARGB(255, 206, 211, 211),
                                        indent: 0,
                                        endIndent: 0,
                                        height: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Telephone",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                      ),
                                      SizedBox(width: size.width*0.135,),
                                      Text(
                                        '+852 ',
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                      )
                                    ]
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      child: Divider(
                                        color: Color.fromARGB(255, 206, 211, 211),
                                        indent: 0,
                                        endIndent: 0,
                                        height: 1,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Fee",
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                      ),
                                      SizedBox(width: size.width*0.27,),
                                      Text(
                                        'doctorPrice',
                                        style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                      )
                                    ]
                                  ),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      child: Divider(
                                        color: Color.fromARGB(255, 206, 211, 211),
                                        indent: 0,
                                        endIndent: 0,
                                        height: 1,
                                    ),
                                  ),
                                   Row(
                                      //padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      children: [Text(
                                    "Qualifications",
                                    style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                                  )]),
                                  Padding(padding: EdgeInsets.only(top: defaultVerPadding/1.5), child: Text(
                                    'description',
                                    textAlign: TextAlign.justify,
                                    overflow: TextOverflow.visible,
                                    maxLines: 5,
                                    style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
                                  )),
                                  const Padding(
                                      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/1.5),
                                      child: Divider(
                                        color: Color.fromARGB(255, 206, 211, 211),
                                        indent: 0,
                                        endIndent: 0,
                                        height: 1,
                                    ),
                                  ),
                                ],
                              )),
                            ))
                            )
                          ),
                          Spacer(),
                          //buttons
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: parentHeight*0.3),
                            child: Padding(
                              padding: EdgeInsets.only(bottom: defaultVerPadding),
                              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: TextButton(
                                    style: ButtonStyle(
                                      side: MaterialStatePropertyAll(BorderSide(color: lighttheme)),
                                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                                      minimumSize: MaterialStatePropertyAll(Size(size.width*0.15, parentHeight*0.1)),
                                      backgroundColor: MaterialStatePropertyAll(Colors.white)
                                    ),
                                    onPressed: (){}, 
                                    child: Icon(Icons.message, color: lighttheme,)
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    final result = await showConfirmDialog(context, "Are you sure to make appointment?");
                                    if (result==true)
                                    Navigator.of(context).push(_createRoute(MakeAppointment(widget.doctor)));
                                  }, 
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20)))),
                                    minimumSize: MaterialStatePropertyAll(Size(size.width*0.65, parentHeight*0.1)),
                                    backgroundColor: MaterialStatePropertyAll(lighttheme)
                                  ),
                                  child: Text('Make Appointment', style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontSize: 15)),)
                                )
                              ],
                            ))
                          )
                        ]
                      );
                      },
                    )
                  )
                ),
              ],
            ),
            Positioned(
            top: size.height * 0.17,
            left: size.width * 0.155,
              child: Container(
              alignment: Alignment.center,
              height: size.height*0.08,
              width:size.width*0.7, 
              decoration: BoxDecoration(
                color: bgColor,
                //border: Border.all(color: lighttheme, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(60)),
              ),
              child: Text(
                      'Dr. ${widget.doctor[0]}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: lighttheme, fontSize: 19)),
                    ),
            )
          ),
          Positioned(
            top: 0,
            left: size.width * 0.35,
            child: Container(
            width: size.width* 0.3,
            height: size.width*0.3,
            //color: Colors.black,
            decoration: BoxDecoration(
                color: bgColor,
                //border: Border.all(color: themeColor),
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(widget.doctor[2]))
              ),
            ),
          )
            
          ],
        )
      )
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