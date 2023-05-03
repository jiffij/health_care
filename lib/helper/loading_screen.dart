// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:simple_login/yannie_version/color.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lighttheme,
      body: Center(
        child: LoadingAnimationWidget.inkDrop(color: Colors.white, size: 50),
      ),
    );
  }
}
