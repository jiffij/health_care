import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.faker,
  }) : super(key: key);

  final Faker faker;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: defaultVerPadding/3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 10,
                      color: goodColor.withOpacity(0.13),
                    ),
                  ],
        ),
        child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(30),
        splashFactory: InkRipple.splashFactory,
        splashColor: lighttheme.withOpacity(0.8),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: defaultHorPadding/2,
            vertical: defaultHorPadding/2,
          ),
          width: size.width * 0.7,
          height: size.height * 0.15,
          child: Row(
        children: [
          Container(
            width: size.height* 0.1,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("https://hips.hearstapps.com/hmg-prod/images/portrait-of-a-happy-young-doctor-in-his-clinic-royalty-free-image-1661432441.jpg?crop=0.66698xw:1xh;center,top&resize=1200:*"))
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
                "Doctor's Name",
                style: GoogleFonts.comfortaa(textStyle: TextStyle(fontSize: 17, color: themeColor, fontWeight: FontWeight.w500)),
              ),
              Flexible(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "Category",
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
                    "\$200 ~ \$300",
                    style: const TextStyle(
                        fontSize: 12,
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
      
    );
  }
}