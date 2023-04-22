import 'dart:convert';

import 'package:flutter/material.dart';

import '../model/article_model.dart';
import 'package:http/http.dart' as http;

//Now let's make the HTTP request services
// this class will alows us to make a simple get http request
// from the API and get the Articles and then return a list of Articles

class ApiService {
  //let's add an Endpoint URL, you can check the website documentation
  // and learn about the different Endpoint
  //for this example I'm going to use a single endpoint

  //NOTE: make sure to use your OWN apikey, you can make a free acount and
  // choose a developer option it's FREE
  // final endPointUrl =
  //     "http://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=07ba0b79e4a0463a8ef2f776604a30bf";
  // Uri endPointUrl = Uri.http("newsapi.org", "/v2/top-headlines", {
  //   'country': 'us',
  //   'category': 'business',
  //   'apiKey': '07ba0b79e4a0463a8ef2f776604a30bf'
  // });
  Uri endPointUrl = Uri.parse(
      "http://newsapi.org/v2/top-headlines?country=us&category=health&apiKey=07ba0b79e4a0463a8ef2f776604a30bf");
  //Now let's create the http request function
  // but first let's import the http package

  Future<List<Article>> getArticle() async {
    http.Response res = await http.get(endPointUrl);

    //first of all let's check that we got a 200 statu code: this mean that the request was a succes
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];
      print('news length');
      print(body.length);
      //this line will allow us to get the different articles from the json file and putting them into a list
      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();
      // for (int i = 0; i < articles.length; i++) {
      //   String u = articles[i].urlToImage;
      //   Uri uri = Uri.dataFromString(u);
      //   if(uri.host.isEmpty){
      //     // URI is not valid
      //     articles.removeAt(i);
      //     i--;
      //   }
      // }
      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}
