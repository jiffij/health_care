import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'; // Chat

import '../main.dart';

import 'ChannelListPage.dart';
import 'ChannelPage.dart';

class ChatSetup extends StatefulWidget {
  const ChatSetup({Key? key, required this.setupChatRoute}) : super(key: key);

  final String setupChatRoute;

  @override
  State<ChatSetup> createState() => _ChatSetupState();
}

class _ChatSetupState extends State<ChatSetup> {
  late final Future<OwnUser> connectionFuture;
  late final client = StreamChatClient(
    '4kvevaagmggn',
    logLevel: Level.OFF,
  );

  @override
  void initState() {
    super.initState();
    connectionFuture = client.connectUser(
      User(id: 'EvaChan_1'),
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiRXZhQ2hhbl8xIn0.4fvK0lD9-8jmmSyV_NrOsd_HOYFLmvQtdh-vE4iO3-8',
    );
  }

  /* backup
  @override
  void initState() {
    super.initState();
    connectionFuture = client.connectUser(
      User(id: 'USER_ID'),
      'TOKEN',
    );
  }
  */

  @override
  void dispose() {
    client.disconnectUser();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: StreamChat(
        client: client,
        child: FutureBuilder(
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
                  return Navigator(
                    initialRoute: widget.setupChatRoute,
                    onGenerateRoute: _onGenerateRoute,
                  );
                }
            }
          },
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeChatChannels:
        page = ChannelListPage(
          client: client,
        );
        break;
      case routeChatChannel:
        final channel = settings.arguments as Channel;
        page = StreamChannel(
          channel: channel,
          child: const ChannelPage(),
        );
        break;
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}
