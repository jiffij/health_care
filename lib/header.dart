import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:simple_login/searchbar.dart';

import 'color.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultVerPadding),
      //margin: EdgeInsets.only(bottom: 0),
      // It will cover 20% of our total height
      height: size.height * 0.14,
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
              left: defaultHorPadding,
              right: defaultHorPadding,
              bottom: defaultVerPadding,
            ),
            height: size.height * 0.25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
              boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 10),
                      blurRadius: 20,
                      color: goodColor.withOpacity(0.1),
                    ),
                  ],
            ),
            child: Row( 
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: EdgeInsets.symmetric(vertical: size.height*0.02), child: Text(DateFormat('dd MMMM, yyyy, EEEE').format(DateTime.now()), style: datetime,)),
                    Text("Hi, Yannie!", style: greeting,),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}