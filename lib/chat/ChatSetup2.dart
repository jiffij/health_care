import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'; // Chat

import '../main.dart';
import 'ChannelListPage2.dart';

import '../helper/firebase_helper.dart';
import '../yannie_version/pages/yannie_welcome.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ChatSetup2 extends StatefulWidget {
  const ChatSetup2({
    super.key,
  });

  @override
  State<ChatSetup2> createState() => _ChatSetup2State();
}

class _ChatSetup2State extends State<ChatSetup2> {
  late final Future<OwnUser> connectionFuture;
  late final client = StreamChat.of(context).client;

  String userID = getUID();

  @override
  void initState() {
    super.initState();
    connectionFuture = client.connectUser(
      User(id: '$userID'),
      '$userToken',
    );
  }

  // backup
  /*
  @override
  void initState() {
    super.initState();
    connectionFuture = client.connectUser(
      User(id: 'EvaChan_1'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiRXZhQ2hhbl8xIn0.4fvK0lD9-8jmmSyV_NrOsd_HOYFLmvQtdh-vE4iO3-8',
    );
  }
  */
  // backup

  @override
  void dispose() {
    client.disconnectUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: connectionFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const ChannelListPage2();
              }
          }
        },
      ),
    );
  }
}
