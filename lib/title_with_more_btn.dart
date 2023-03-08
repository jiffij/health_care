import 'package:flutter/material.dart';
import 'color.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key? key,
    required this.title,
    required this.press,
    required this.withBtn
  }) : super(key: key);
  final String title;
  final Function press;
  final bool withBtn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultVerPadding/2, left: defaultHorPadding, right: defaultHorPadding/1.5),
      child: Row(
        children: <Widget>[
          Text(title, style: mainStyle20,),
          Spacer(),
          (withBtn)? TextButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.white),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10)))),
            ),
            child: Text("See All", style: mainStyle12,),
            onPressed: () {},
          ):Container(),
        ],
      ),
    );
  }
}
