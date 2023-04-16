import 'package:flutter/material.dart';
import 'color.dart';
import 'doctor.dart';
import 'package:google_fonts/google_fonts.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen(
    {
      Key? key,
      required Doctor this.doctor
    }) : super(key: key);
    @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();

  final Doctor doctor;
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  
  bool isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    //final args = ModalRoute.of(context)?.settings.arguments as Doctor;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: lighttheme,
      body: SafeArea(child: Stack(
        children: [
              Column(
                children: [
                  Container(
                    color: lighttheme,
                    height: size.height*0.25,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: lighttheme),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60)),
                        boxShadow: [BoxShadow(offset: const Offset(1, 0),
                          blurRadius: 100,
                          color: goodColor.withOpacity(0.13),)]
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: defaultHorPadding, right: defaultHorPadding, bottom: defaultVerPadding*1.5, top: defaultVerPadding*2.5),
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Gender",
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                    ),
                    SizedBox(width: size.width*0.2,),
                    Text(
                      widget.doctor.doctorGender,
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
                      "Specialty",
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                    ),
                    SizedBox(width: size.width*0.16,),
                    Text(
                      widget.doctor.doctorSpecialty,
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
                      widget.doctor.doctorYearOfExperience,
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
                      '+852 ${widget.doctor.doctorTel}',
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
                      widget.doctor.doctorPrice,
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
                Text(
                  "Qualifications",
                  style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
                ),
                Padding(padding: EdgeInsets.only(top: defaultVerPadding/1.5), child: Text(
                  '${widget.doctor.doctorName} • ${widget.doctor.doctorDescription} ',
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
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:   ElevatedButton(
                      onPressed: () {}, 
                      style: ButtonStyle(
                        //splashFactory: InkSplash.splashFactory,
                        overlayColor: MaterialStatePropertyAll(themeColor.withOpacity(0.1)),
                        minimumSize: MaterialStatePropertyAll(Size(60,60)),
                        side: MaterialStatePropertyAll(BorderSide(
                          width: 1,
                          color: themeColor,
                        )),
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))))
                      ),
                      child: Icon(Icons.chat, color: lighttheme,))),

                    Container(
                      color: Colors.transparent,
                      width: size.width*0.65,
                      child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Make Appointment",
                                            style: GoogleFonts.comfortaa(textStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17)),
                                          ),
                                          style: ButtonStyle(
                                            minimumSize: MaterialStatePropertyAll(Size(size.width*0.5,40)),
                                            padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 20, horizontal: 20)),
                                              backgroundColor:
                                                  MaterialStateProperty.all(
                                                      themeColor),
                                              overlayColor: MaterialStateProperty.all(Colors.white),   
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ))),
                                        ),)
                  ],
                )]))
                    )
                  )
                ]
              ),
              AppBar(
                  //title: Text('Search For Doctor'),
                  elevation: 0,
                  toolbarHeight: 80,
                  backgroundColor: Colors.transparent,
                  titleTextStyle: appbar_title,
                  centerTitle: true,
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
          Positioned(
            top: size.height * 0.21,
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
                      widget.doctor.doctorName,
                      style: GoogleFonts.comfortaa(textStyle: TextStyle(color: lighttheme, fontSize: 19)),
                    ),
            )
          ),
          Positioned(
            top: size.height * 0.05,
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
                  image: AssetImage('assets/doctor_images/${widget.doctor.doctorPicture}'))
              ),
            ),
          )
          //Column(
            //children: [
          // Container(
          //   padding: const EdgeInsets.all(16),
          //   height: MediaQuery.of(context).size.height * 0.5,
          //   decoration: BoxDecoration(
          //     color: Colors.white,
          //     borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))
          //   ),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const SizedBox(
          //         height: 24,
          //       ),
          //       Hero(
          //         tag: doctor.doctorName,
          //         child: Material(
          //           color: Colors.transparent,
          //           child: Text(
          //             doctor.doctorName,
          //             style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 25)),
          //           ),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 8,
          //       ),
          //       Text(
          //         '${doctor.doctorCategory} • ${doctor.doctorHospital} ',
          //         style: GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15)),
          //       ),
          //       const SizedBox(
          //         height: 16,
          //       ),
          //       Text(
          //         '${doctor.doctorName} • ${doctor.doctorDescription} ',
          //         overflow: TextOverflow.ellipsis,
          //         maxLines: 5,
          //         style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color(0xff91919F), fontSize: 15)),
          //       ),
          //       const SizedBox(
          //         height: 16,
          //       ),
          //       const Spacer(),
          //       IntrinsicHeight(
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Column(
          //               children: [
          //                 Text(
          //                   'Experience',
          //                   style:
          //                       Theme.of(context).textTheme.headline4!.copyWith(
          //                             color: kBlackColor900,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                 ),
          //                 const SizedBox(
          //                   height: 8,
          //                 ),
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.end,
          //                   children: [
          //                     Text(
          //                       doctor.doctorYearOfExperience,
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline2!
          //                           .copyWith(
          //                             color: kBlueColor,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                     ),
          //                     const SizedBox(
          //                       width: 4,
          //                     ),
          //                     Text(
          //                       'yr',
          //                       style: Theme.of(context).textTheme.headline5,
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ),
          //             const SizedBox(
          //               width: 8,
          //             ),
          //             const VerticalDivider(
          //               thickness: 1,
          //               color: kGreyColor400,
          //             ),
          //             Column(
          //               children: [
          //                 Text(
          //                   'Patient',
          //                   style:
          //                       Theme.of(context).textTheme.headline4!.copyWith(
          //                             color: kBlackColor900,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                 ),
          //                 const SizedBox(
          //                   height: 8,
          //                 ),
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.end,
          //                   children: [
          //                     Text(
          //                       doctor.doctorNumberOfPatient,
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline2!
          //                           .copyWith(
          //                             color: kBlueColor,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                     ),
          //                     const SizedBox(
          //                       width: 4,
          //                     ),
          //                     Text(
          //                       'ps',
          //                       style: Theme.of(context).textTheme.headline5,
          //                     )
          //                   ],
          //                 )
          //               ],
          //             ),
          //             const SizedBox(
          //               width: 8,
          //             ),
          //             const VerticalDivider(
          //               thickness: 1,
          //               color: kGreyColor400,
          //             ),
          //             Column(
          //               children: [
          //                 Text(
          //                   'Rating',
          //                   style:
          //                       Theme.of(context).textTheme.headline4!.copyWith(
          //                             color: kBlackColor900,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                 ),
          //                 const SizedBox(
          //                   height: 8,
          //                 ),
          //                 Row(
          //                   crossAxisAlignment: CrossAxisAlignment.end,
          //                   children: [
          //                     Text(
          //                       doctor.doctorRating,
          //                       style: Theme.of(context)
          //                           .textTheme
          //                           .headline2!
          //                           .copyWith(
          //                             color: kBlueColor,
          //                             fontWeight: FontWeight.w400,
          //                           ),
          //                     ),
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //       const Spacer(),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Container(
          //             height: 56,
          //             width: 56,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(16),
          //               color: kBlueColor,
          //               // image: const DecorationImage(
          //               //   image: Svg(
          //               //     'assets/svg/icon-chat.svg',
          //               //     size: Size(
          //               //       36,
          //               //       36,
          //               //     ),
          //               //   ),
          //               // ),
          //             ),
          //           ),
          //           const SizedBox(
          //             width: 16,
          //           ),
          //           Container(
          //             height: 56,
          //             width: MediaQuery.of(context).size.width - 104,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(16),
          //               color: kGreenColor,
          //             ),
          //             child: Center(
          //               child: Text(
          //                 'Make an Appoinment',
          //                 style:
          //                     Theme.of(context).textTheme.headline5!.copyWith(
          //                           color: kWhiteColor,
          //                           fontWeight: FontWeight.w700,
          //                         ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // )
        //],
      //),
      ]))
    );
  }
}