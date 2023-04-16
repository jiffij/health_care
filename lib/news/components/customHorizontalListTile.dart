import '../model/article_model.dart';
import '../pages/articles_details_page.dart';
import 'package:flutter/material.dart';

Widget customHorizontalListTile(Article article, BuildContext context) {
  double height = MediaQuery.of(context).size.height * 0.8;
  double width = MediaQuery.of(context).size.width * 0.15;
  
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ArticlePage(
                    article: article,
                  )));
    },
    child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              //let's add the height

              image: DecorationImage(
                  image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
  );
}
