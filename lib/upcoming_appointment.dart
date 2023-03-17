import 'package:flutter/material.dart';

import 'color.dart';

class Upcoming extends StatelessWidget {
  const Upcoming({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(
          top: defaultVerPadding,
          //bottom: defaultVerPadding/2,
          left: defaultHorPadding/3,
          right: defaultHorPadding/3
        ),
      child: Row(
        children: <Widget>[
          AppointmentCard(
            press: () {},
          ),
          AppointmentCard(
            press: () {},
          ),
          AppointmentCard(press: () {}),
          AppointmentCard(press: () {}),
          AppointmentCard(press: () {}),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatefulWidget {

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();

  const AppointmentCard({
    Key? key,
    required this.press,
  }) : super(key: key);
  final Function press;

}

class _AppointmentCardState extends State<AppointmentCard> {
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
            color: lighttheme.withOpacity(0.9),
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
                      margin: EdgeInsets.only(right: parentWidth*0.03),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white
                      ),
                      child: Text('12\nMar', style: timestamp, textAlign: TextAlign.center,),
                  ),
                  Container(
                      width: parentWidth*0.6,
                      height: parentHeight,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: Padding(padding: EdgeInsets.symmetric(horizontal: parentWidth*0.1), child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('08:30 AM', style: card, textAlign: TextAlign.left,),
                          Flexible(
                            child: Text(
                              'Mim Akhter',
                              style: card2,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Flexible(
                            child: Text(
                              'Dermatology',
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
