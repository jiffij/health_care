import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:collection/collection.dart'; // For using firstWhereOrNull()
import 'StreamChannelListPage.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  late StreamChatClient client;

  @override
  void initState() {
    super.initState();
    client = StreamChatClient(
      "4kvevaagmggn",
      logLevel: Level.INFO,
      connectTimeout: Duration(milliseconds: 6000),
      receiveTimeout: Duration(milliseconds: 6000),
    );

    // User 1
    final user = User(id: "EvaChan_1", extraData: {
      "name": "Eva Chan",
      "image":
          "https://serving.photos.photobox.com/98717916301912f7dfba33d6787c095532b401b2ae7f44741223486f2736ffbea9f7f813.jpg",
    });

    client.connectUser(user,
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiRXZhQ2hhbl8xIn0.4fvK0lD9-8jmmSyV_NrOsd_HOYFLmvQtdh-vE4iO3-8");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      body: const ChannelListPage(),
    );
  }
}
