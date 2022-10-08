import 'package:flutter/material.dart';
import 'main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var displayName;

  @override
  void initState() {
    displayName = auth.currentUser!.displayName;
    print(displayName);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
          children: [
          SizedBox(
            width: width,
            height: height*0.1,
            child: Card(child: Text('Hello World!')),
          ),
          Text('Hi, ' + displayName),
          ]
          )
        ),
      ),
    );
  }
}
