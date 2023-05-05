import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'; // Chat

import '../main.dart';
import 'ChannelListPage2.dart';

import '../helper/firebase_helper.dart';
import '../yannie_version/pages/yannie_welcome.dart';
import 'package:cloud_functions/cloud_functions.dart';

class ChatSetup2D extends StatefulWidget {
  const ChatSetup2D(this.fullname, {Key? key}) : super(key: key);

  @override
  State<ChatSetup2D> createState() => _ChatSetup2DState();

  final String fullname;
}

class _ChatSetup2DState extends State<ChatSetup2D> {
  late final Future<OwnUser> connectionFuture;
  late final client = StreamChat.of(context).client;
  //String fullname = 'Ivy';

  String userID = getUID();

  @override
  void initState() {
    super.initState();
    //start();
    connectionFuture = client.connectUser(
      User(id: '$userID', extraData: {
        "name": "${widget.fullname}",
      }),
      '$userToken',
    );
  }

  /*
  void start() async {
    Map<String, dynamic>? user = await readFromServer('doctor/$userID');
    fullname = user?['first name'] + ' ' + user?['last name'];
    userID = getUID();
    //setState(() {print(user);});
    setState(() {});
  }
  */

  /* Work
  @override
  void initState() {
    super.initState();
    connectionFuture = client.connectUser(
      User(id: '$userID'),
      '$userToken',
    );
  }
  */

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
