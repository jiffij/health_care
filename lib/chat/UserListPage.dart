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
      body: RefreshIndicator(
        onRefresh: () => userListController.refresh(),
        child: StreamUserListView(
          controller: userListController,
          itemBuilder: (context, users, index, defaultWidget) {
            return defaultWidget.copyWith(
              selected: _selectedUsers.contains(users[index]),
            );
          },
          /*
          onUserTap: (user) {Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                ),
              ),
            )},
            */
          // Backup

          onUserTap: (user) {
            setState(() {
              _selectedUsers.add(user);
            });
          },
        ),
      ),
    );
  }

  // Built - Select user to add
}



/*
      body: PagedValueListenableBuilder<int, User>(
        valueListenable: userListController,
        builder: (context, value, child) {
          return value.when(
            (users, nextPageKey, error) => LazyLoadScrollView(
              onEndOfPage: () async {
                if (nextPageKey != null) {
                  userListController.loadMore(nextPageKey);
                }
              },
              // backup
              // child: ListView.builder(
              // backup
              child: StreamUsersListView(
                controller: userListController,

                /// We're using the users length when there are no more
                /// pages to load and there are no errors with pagination.
                /// In case we need to show a loading indicator or and error
                /// tile we're increasing the count by 1.
                itemCount: (nextPageKey != null || error != null)
                    ? users.length + 1
                    : users.length,

                // Backup

                itemBuilder: (BuildContext context, int index) {
                  if (index == users.length) {
                    if (error != null) {
                      return TextButton(
                        onPressed: () {
                          userListController.retry();
                        },
                        child: Text(error.message),
                      );
                    }
                    return CircularProgressIndicator();
                  }

                  final _item = users[index];
                  return ListTile(
                    title: Text(_item.name ?? ''),
                  );
                },

                // Backup
              ),
            ),
            loading: () => const Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e) => Center(
              child: Text(
                'Oh no, something went wrong. '
                'Please check your config. $e',
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
  // Test

  /*
  @override
  Widget build(BuildContext context) => Scaffold(
        body: PagedValueListenableBuilder<int, User>(
          valueListenable: userListController,
          builder: (context, value, child) {
            return value.when(
              (users, nextPageKey, error) => LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    userListController.loadMore(nextPageKey);
                  }
                },
                // backup
                // child: ListView.builder(
                // backup
                child: StreamUsersListView(
                  controller: userListController,

                  /// We're using the users length when there are no more
                  /// pages to load and there are no errors with pagination.
                  /// In case we need to show a loading indicator or and error
                  /// tile we're increasing the count by 1.
                  itemCount: (nextPageKey != null || error != null)
                      ? users.length + 1
                      : users.length,

                  // Backup

                  itemBuilder: (BuildContext context, int index) {
                    if (index == users.length) {
                      if (error != null) {
                        return TextButton(
                          onPressed: () {
                            userListController.retry();
                          },
                          child: Text(error.message),
                        );
                      }
                      return CircularProgressIndicator();
                    }

                    final _item = users[index];
                    return ListTile(
                      title: Text(_item.name ?? ''),
                    );
                  },

                  // Backup
                ),
              ),
              loading: () => const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e) => Center(
                child: Text(
                  'Oh no, something went wrong. '
                  'Please check your config. $e',
                ),
              ),
            );
          },
        ),
      );
      */


    /*
    @override
    Widget build(BuildContext context) {
      return RefreshIndicator(
        onRefresh: () => _userListController.refresh(),
        child: StreamUserListView(
          controller: _userListController,
          itemBuilder: (context, users, index, defaultWidget) {
            return defaultWidget.copyWith(
              selected: _selectedUsers.contains(users[index]),
            );
          },
          onUserTap: (user) {
            setState(() {
              _selectedUsers.add(user);
            });
          },
        ),
      );
    }
  }
  */