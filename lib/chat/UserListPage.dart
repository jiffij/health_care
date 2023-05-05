import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'ChannelPage.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late final StreamUserListController userListController =
      StreamUserListController(
    client: StreamChatCore.of(context).client,
    limit: 25,
    filter: Filter.and(
      [Filter.notEqual('id', StreamChat.of(context).currentUser!.id)],
    ),
    sort: [
      const SortOption(
        'name',
        direction: 1,
      ),
    ],
  );

  @override
  void initState() {
    userListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    userListController.dispose();
    super.dispose();
  }

  // Test - Tap to create channel
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => userListController.refresh(),
        child: StreamUserListView(
          controller: userListController,
          itemBuilder: (context, users, index, defaultWidget) {
            return defaultWidget.copyWith(
              selected: _selectedUsers.contains(users[index]),
            );
          },
          onUserTap: (user)  => Navigator.push(
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
  */
  // Test - Tap to create channel

  // Built - Select user to add
  Set<User> _selectedUsers = {};

  /*
  final channel = client.channel('messaging', id: 'flutterdevs');
  await channel.watch();
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StreamChatTheme.of(context).colorTheme.appBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: StreamChatTheme.of(context).colorTheme.barsBg,
        leading: const StreamBackButton(),
        title: Text(
          'User List',
          style: StreamChatTheme.of(context).textTheme.headlineBold.copyWith(
              color: StreamChatTheme.of(context).colorTheme.textHighEmphasis),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () => userListController.refresh(),
        child: StreamUserListView(
          controller: userListController,
          itemBuilder: (context, users, index, defaultWidget) {
            return defaultWidget.copyWith(
              selected: _selectedUsers.contains(users[index]),
            );
          },
          onUserTap: (user) {
            setState(() {
              _selectedUsers.add(user);
            });

            createChannel(context);
          },
        ),
      ),
    );
  }

  Future<void> createChannel(BuildContext context) async {
    final core = StreamChatCore.of(context);

    final channel = core.client.channel('messaging', extraData: {
      'members': [
        core.currentUser!.id,
        ..._selectedUsers.map((e) => e.id),
      ]
    });
    await channel.watch();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => StreamChannel(
          channel: channel,
          child: const ChannelPage(),
        ),
      ),
    );
  }
}
