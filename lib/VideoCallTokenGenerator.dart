import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

//token generator
import 'package:http/http.dart' as http;
import 'dart:convert';

String tokenServerUrl =
    "https://agora-token-service-production-14e6.up.railway.app/";

const String appId = "fa12dc73db1e4f769dcb6fd794785382";
String channelName = "testing01";
String token =
    "007eJxTYDi8KctRXCo95Qjv65iaBRt4+F0CZWfsulHce2DC6qJtjs8UGNISDY1Sks2NU5IMU03SzM0sU5KTzNJSzC1NzC1MjS2Mvq7Yl9wQyMhQEC3BwAiFID4nQ0lqcUlmXrqBIQMDAOSbITg=";
int uid = 0;

class VideoCalling extends StatefulWidget {
  const VideoCalling({Key? key}) : super(key: key);

  @override
  _VideoCallingState createState() => _VideoCallingState();
}

class _VideoCallingState extends State<VideoCalling> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: appId,
      channelName: channelName,
      tempToken: token,
      uid: uid,
    ),
  );
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  void initAgora() async {
    await client.initialize();
  }

  //Build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Agora UI Kit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
              ),
              AgoraVideoButtons(
                client: client,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//get a video call token through http request
