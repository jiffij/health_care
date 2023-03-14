import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart'; // Chat
import 'package:collection/collection.dart'; // Chat - For using firstWhereOrNull()
import 'package:provider/provider.dart';

// Chat
const routeHome = '/';
const routePrefixChat = '/chat/';
const routeChatHome = '$routePrefixChat$routeChatChannels';
const routeChatChannels = 'chat_channels';
const routeChatChannel = 'chat_channel';
// Chat

// Chat Setup

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

  // late StreamChatClient client;

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

  @override
  void initState() {
    super.initState();
    final user = User(id: "EvaChan_1", extraData: {
      "name": "Eva Chan",
      "image":
          "https://serving.photos.photobox.com/98717916301912f7dfba33d6787c095532b401b2ae7f44741223486f2736ffbea9f7f813.jpg",
    });
    connectionFuture = client.connectUser(
      user,
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiRXZhQ2hhbl8xIn0.4fvK0lD9-8jmmSyV_NrOsd_HOYFLmvQtdh-vE4iO3-8',
    );
  }

  /*
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

// ChannelListPage
class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
    required this.client,
  });

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _popChatPages() {
    final nav = context.read<GlobalKey<NavigatorState>>();
    nav.currentState!.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _popChatPages();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              _popChatPages();
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: StreamChannelListView(
            controller: _controller,
            onChannelTap: (channel) {
              Navigator.pushNamed(context, routeChatChannel,
                  arguments: channel);
            },
          ),
        ),
      ),
    );
  }
}

// Channel Page
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
