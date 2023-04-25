import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';

const themeColor = Color.fromARGB(255, 47, 106, 173);
const lighttheme = Color.fromARGB(255, 27, 89, 161);
const bgColor = Color(0xFFE6EFF9);
const goodColor = Color.fromARGB(97, 47, 106, 173);
const double defaultHorPadding = 30;
const double defaultVerPadding = 25;

TextStyle mainStyle10 = GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 10));
TextStyle mainStyle20 = GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.black, fontSize: 17, ));
TextStyle mainStyle12 = GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 12));
TextStyle greeting = GoogleFonts.comfortaa(textStyle: TextStyle(color: lighttheme, fontSize: 25));
TextStyle datetime = GoogleFonts.comfortaa(textStyle: TextStyle(color: lighttheme, fontSize: 15));
TextStyle label = GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15));
TextStyle timestamp = GoogleFonts.comfortaa(textStyle: TextStyle(color: themeColor, fontSize: 15, height: 1.5, fontWeight: FontWeight.w700));
TextStyle card = GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontSize: 14, height: 2, fontWeight: FontWeight.w700));
TextStyle card2 = GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontSize: 16, height: 2, fontWeight: FontWeight.w700));
TextStyle appbar_title = GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500));

List<BoxShadow> defaultShadow = [BoxShadow(
                      offset: const Offset(0, 10),  
                      blurRadius: 30,
                      color: goodColor.withOpacity(0.13),
                    )];

const double nav = 70;

AppBar appbar = AppBar();






Color greenDark = const Color(0xff023537);
Color greenMed = const Color(0xff12999E);
Color greenLight = const Color(0xff4CB2B6);
Color greenTint1 = const Color(0xffC5DDDA);
Color greenTint2 = const Color(0xffE3F0EF);
Color greenTint3 = const Color(0xffE9F2F1);
Color dimGrey = const Color(0xff5C5C5C);
Color medGrey = const Color(0xffB0B0B0);
Color lightGrey = const Color(0xffEAEAEA);
Color whitishGrey = const Color(0xffF2F2F2);
Color redColor = const Color(0xffFF5C5C);


// Color constant
const kBlueColor = Color(0xFF4485FD);
const kGreenColor = Color(0xFF00CC6A);
const kGreenLightColor = Color(0xffCCF5E1);
const kRedColor = Color(0xffCC4900);
const kRedLightColor = Color(0xffF7E4D9);
const kWhiteColor = Color(0xFFFFFFFF);
const kBlackColor900 = Color(0xFF25282B);
const kBlackColor800 = Color(0xFF404345);
const kGreyColor900 = Color(0xFFA0A4A8);
const kGreyColor800 = Color(0xFFAAAAAA);
const kGreyColor700 = Color(0xFFC4C4C4);
const kGreyColor600 = Color(0xFFEAEAEA);
const kGreyColor500 = Color(0xFFF6F6F6);
const kGreyColor400 = Color(0x50CACCCF);
const kYellowColor = Color(0xFFFFE848);