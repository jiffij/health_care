import 'package:flutter/material.dart';

// Chat
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:provider/provider.dart';

import '../main.dart';
// Chat

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
