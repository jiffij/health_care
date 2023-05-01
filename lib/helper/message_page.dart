import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessagePage extends StatefulWidget {
  final String message;
  final Color color;
  final int duration;

  MessagePage({required this.message, required this.color, required this.duration});

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  void initState() {
    super.initState();
    // Pop the page after 5 seconds
    Future.delayed(Duration(seconds: widget.duration), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Center(
        child: Text(
          widget.message,
          textAlign: TextAlign.center,
          style: GoogleFonts.comfortaa(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
