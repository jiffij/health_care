import 'package:flutter/material.dart';

import 'color.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key, }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.symmetric(vertical: defaultVerPadding/2, horizontal: defaultHorPadding/1.5),
            child: ElevatedButton(
            style: ButtonStyle(
              //maximumSize: MaterialStatePropertyAll(Size(5, 5)),
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
            ));
  }
}