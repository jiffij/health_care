import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:collection/collection.dart'; // For using firstWhereOrNull()

void main() async {
  // *** implementation using my API key
  // client-side you initialize the Chat client with your API key
  final client = StreamChatClient(
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

  await client.connectUser(user,
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiRXZhQ2hhbl8xIn0.4fvK0lD9-8jmmSyV_NrOsd_HOYFLmvQtdh-vE4iO3-8");

  // set up a channel
  /// Creates a channel using the type `messaging` and `flutterdevs`.
  /// Channels are containers for holding messages between different members. To
  /// learn more about channels and some of our predefined types, checkout our
  /// our channel docs: https://getstream.io/chat/docs/flutter-dart/creating_channels/?language=dart
  /*
  final channel = client.channel(
    'messaging',
    id: 'AliceWilliams_1_channel',
    extraData: {
      'name': 'Alice Williams',
    },
  );

  /// `.watch()` is used to create and listen to the channel for updates. If the
  /// channel already exists, it will simply listen for new events.
  await channel.watch();
  */

  /*
  // Querying Channels - retrieve a list of channels
  final filter = Filter.in_('members', ['john']);
  final channels = await client
      .queryChannels(
        filter: filter,
        // sort: sort,
        sort: [SortOption("last_message_at", direction: SortOption.DESC)],
        watch: true,
        state: true,
      )
      .last;

  channels.forEach((Channel c) {
    print("${c.extraData['name']} ${c.cid}");
  });
  */

  runApp(
    MyApp(
      client: client,
      //channel: channel,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
    //required this.channel,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: const ChannelListPage(),
    );
  }
}

/*
  /// The channel we'd like to observe and participate.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, widget) {
        return StreamChat(
          client: client,
          child: widget,
        );
      },
      home: StreamChannel(
        channel: channel,
        child: const ChannelPage(),
      ),
    );
  }
}
*/

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  void initState() {
    _listController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

// Channel Preview - With header

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: StreamChannelListHeader(
          centerTitle: true, showConnectionStateTile: true,
          //onNewChatButtonTap - Pending to do
        ),
        body: RefreshIndicator(
          onRefresh: _listController.refresh,
          child: StreamChannelListView(
            controller: _listController,
            onChannelTap: (channel) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                ),
              ),
            ),
          ),
        ),
      );
}

/*
// Default Channel Preview - Without header
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
*/

// Customize Channel Preview
/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        itemBuilder: _channelTileBuilder,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _channelTileBuilder(BuildContext context, List<Channel> channels,
      int index, StreamChannelListTile defaultChannelTile) {
    final channel = channels[index];
    final lastMessage = channel.state?.messages.reversed.firstWhereOrNull(
      (message) => !message.isDeleted,
    );

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

    final theme = StreamChatTheme.of(context);

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const ChannelPage(),
            ),
          ),
        );
      },
      leading: StreamChannelAvatar(
        channel: channel,
      ),
      title: StreamChannelName(
        channel: channel,
        textStyle: theme.channelPreviewTheme.titleStyle!.copyWith(
          color: theme.colorTheme.textHighEmphasis.withOpacity(opacity),
        ),
      ),
      subtitle: Text(subtitle),
      trailing: channel.state!.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state!.unreadCount.toString()),
            )
          : const SizedBox(),
      enableFeedback: true,
    );
  }
}
*/

/// Displays the list of messages inside the channel
class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(
        centerTitle: true,
        showConnectionStateTile: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              messageBuilder: (context, details, messages, defaultMessage) {
                return defaultMessage.copyWith(
                  showFlagButton: false,
                  showEditMessage: details.isMyMessage,
                  showCopyMessage: true,
                  showDeleteMessage: details.isMyMessage,
                  showReplyMessage: true,
                  showThreadReplyMessage: true,
                );
              },
              threadBuilder: (_, parentMessage) => ThreadPage(
                parent: parentMessage,
              ),
            ),
          ),
          const StreamMessageInput(),
        ],
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    Key? key,
    this.parent,
  }) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent!,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent!.id),
            ),
          ),
        ],
      ),
    );
  }
}











// Original - Master
/*
// import 'dart:html';
import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AgoraConfigWithUIKit.dart';

FirebaseAuth auth = FirebaseAuth.instance;

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // binding with plugin with flutter engine
  await Firebase.initializeApp(); // make sure firebase is init
  runApp(const MyApp()); //MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: loginScreen(),
    );
  }
}
*/