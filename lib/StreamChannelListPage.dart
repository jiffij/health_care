import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:collection/collection.dart'; // For using firstWhereOrNull()

import 'StreamChannelPage.dart';

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
