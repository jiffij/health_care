//Now let's create the article model
// for that we just need to copy the property from the json structure
// and make a dart object

import 'source_model.dart';

class Article {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  //Now let's create the constructor
  Article(
      {required this.source,
      required this.author,
      required this.title,
      required this.description,
      required this.url,
      required this.urlToImage,
      required this.publishedAt,
      required this.content});

  //And now let's create the function that will map the json into a list
  factory Article.fromJson(Map<String, dynamic> json) {
    print(json['urlToImage']);
    return Article(
      source: Source.fromJson(json['source']),
      author: (json['author'] == null ? "" : json['author'] as String),
      title: json['title'] as String,
      description:
          (json['description'] == null ? "" : json['description'] as String),
      url: json['url'] as String,
      urlToImage:
          (json['urlToImage'] == null ? "https://firebasestorage.googleapis.com/v0/b/hola-85371.appspot.com/o/newsloading.jpg?alt=media&token=ce51c4d2-2fbc-40dd-8d21-7db58dabf79c" : json['urlToImage'] as String),
      publishedAt: json['publishedAt'] as String,
      content: json['content'] ?? "",
    );
  }
}
