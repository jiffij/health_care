import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_uikit/agora_uikit.dart';

// Create the variables you use to initiate and join a channel
const appId = 'fa12dc73db1e4f769dcb6fd794785382';
String channelName = 'testing02';
String token =
    '007eJxTYAh6w+Hs6jPhjXXy+uKoB5ytLlfzYqZ5WC3WbeyZIFCwL1qBIS3R0Cgl2dw4Jckw1STN3MwyJTnJLC3F3NLE3MLU2MJogdXx5IZARoZzRh0MjFAI4nMylKQWl2TmpRsYMTAAAIrjIAI=';
int uid = 0; // uid of the local user

bool _isInitialized = false; // Testing

class VideoCallWithUIKit extends StatefulWidget {
  const VideoCallWithUIKit({Key? key}) : super(key: key);

  @override
  _VideoCallWithUIKitState createState() => _VideoCallWithUIKitState();
}

class _VideoCallWithUIKitState extends State<VideoCallWithUIKit> {
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

  Future<void> initAgora() async {
    await client.initialize();

    // Testing
    setState(() {
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // From YouTube
          title: const Text('Video Call with Agora UI Kit'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              AgoraVideoViewer(
                client: client,
                layoutType: Layout.floating,
                enableHostControls: true, // Add this to enable host controls
                showNumberOfUsers: true,
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
