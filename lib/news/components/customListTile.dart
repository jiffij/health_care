import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:simple_login/yannie_version/color.dart';

import '../model/article_model.dart';
import '../pages/articles_details_page.dart';
import 'package:flutter/material.dart';

import '../web_view.dart';


Widget customListTile(Article article, BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.push(
              context,
              _createRoute(MyWebView(url: article.url)),
            );
    },
    child: Container(
      margin: EdgeInsets.all(12.0),
      padding: EdgeInsets.all(defaultHorPadding/1.5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3.0,
            ),
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              //let's add the height

              image: DecorationImage(
                  image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            padding: EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Text(
              article.source.name,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Text(
            article.title,
            style: GoogleFonts.comfortaa(textStyle: TextStyle(
              fontSize: 16.0,
            )),
          ),
          // GestureDetector(
          //   child: Text(
          //   article.url,
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16.0,
          //   ),
          // ),
          // onTap: (){
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(builder: (context) => MyWebView(url: article.url)),
          //   );
          // },
          // ),
          
        ],
      ),
    ),
  );
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
