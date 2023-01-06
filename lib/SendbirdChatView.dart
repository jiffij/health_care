import 'dart:async';
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_sdk/sendbird_sdk.dart';

// const String appId = "2742FF7C-48D1-40CE-B88D-3AE6B49C29A3";

class ChatView extends StatefulWidget {
  final String appId;
  final String userId;
  final List<String> otherUserIds;

  const ChatView(
      {Key? key,
      required this.appId,
      required this.userId,
      required this.otherUserIds})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with ChannelEventHandler {
  List<BaseMessage> _messages = [];
  GroupChannel? _channel;

  @override
  void initState() {
    load();
    SendbirdSdk().addChannelEventHandler("chat", this);
    super.initState();
  }

  @override
  void dispose() {
    SendbirdSdk().removeChannelEventHandler("chat");
    super.dispose();
  }

  @override
  void onMessageReceived(BaseChannel channel, BaseMessage message) {
    setState(() {
      _messages.add(message);
    });
    super.onMessageReceived(channel, message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Sendbird Chat")),
        body: DashChat(
            messages: asDashChatMessages(_messages),
            user: asDashChatUser(SendbirdSdk().currentUser),
            onSend: (newMessage) {}));
  }

  ChatUser asDashChatUser(User? user) {
    if (user == null) {
      return ChatUser(
        uid: "",
        name: "",
        avatar: "",
      );
    }
    return ChatUser(
      uid: user.userId,
      name: user.nickname,
      avatar: user.profileUrl,
    );
  }

  List<ChatMessage> asDashChatMessages(List<BaseMessage> messages) {
    return [
      for (BaseMessage sbm in messages)
        ChatMessage(text: sbm.message, user: asDashChatUser(sbm.sender))
    ];
  }

  void load() async {
    // USER_ID should be a unique string to your Sendbird application.
    try {
      // Initialize the Chat SDK + Connect to the Sendbird server
      final sendbird = SendbirdSdk(appId: widget.appId);
      final _user = await sendbird.connect(widget.userId);

      // Get any existing channel between users
      final query = GroupChannelListQuery()
        ..limit = 1
        ..userIdsExactlyIn = widget.otherUserIds;

      List<GroupChannel> channels = await query.loadNext();

      GroupChannel aChannel;
      if (channels.length == 0) {
        // Create a new channel if no channels exist
        aChannel = await GroupChannel.createChannel(GroupChannelParams()
          ..userIds = widget.otherUserIds + [widget.userId]);
      } else {
        aChannel = channels[0];
      }

      // Get messages from channel
      List<BaseMessage> messages = await aChannel.getMessagesByTimestamp(
          DateTime.now().millisecondsSinceEpoch * 1000, MessageListParams());

      // Set the data
      setState(() {
        _messages = messages;
        _channel = aChannel;
      });

      /*
      // Send message
      try {
        final params = UserMessageParams(message: MESSAGE)
            ..data = DATA
            ..customType = CUSTOM_TYPE;

        final preMessage = _channel.GroupChannel.sendUserMessage(params, onCompleted: (msg, error) {
            // The message is successfully sent to the channel.
            // The current user can receive messages from other users
            // through the onMessageReceived() method in event handlers.
        });
        } catch (e) {
        // Handle error.
        }
      */

    } catch (e) {
      // Handle error.
      print(e);
    }
  }
}



/*
Future<UserMessage> sendUserMessage({
  required ChannelType channelType,
  required String channelUrl,
  required UserMessageParams params,
  String? senderId,
  List<String>? additionalMentionedUserIds,
  bool markAsRead = false,
})
*/