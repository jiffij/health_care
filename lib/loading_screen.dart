// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 50),
      ),
    );
  }
}
