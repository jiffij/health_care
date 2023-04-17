// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:simple_login/video_call/pages/connect.dart';
import 'package:simple_login/welcome.dart';
import 'login_screen.dart';
// import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Chat - Integration
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:provider/provider.dart';

import '../chat/ChatSetup.dart';

const routeHome = '/';
const routePrefixChat = '/chat/';
const routeChatHome = '$routePrefixChat$routeChatChannels';
const routeChatChannels = 'chat_channels';
const routeChatChannel = 'chat_channel';
// Chat - Integration

FirebaseAuth auth = FirebaseAuth.instance;

final GoogleSignIn _googleSignIn = GoogleSignIn();

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // binding with plugin with flutter engine
  await Firebase.initializeApp(); // make sure firebase is init
  runApp(const MyApp()); //MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: navigatorKey,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        initialRoute: routeHome,
        onGenerateRoute: (settings) {
          late Widget page;
          if (settings.name == routeHome) {
            page = const welcome();
          } else if (settings.name!.startsWith(routePrefixChat)) {
            final subRoute = settings.name!.substring(routePrefixChat.length);
            page = ChatSetup(
              setupChatRoute: subRoute,
            );
          } else {
            throw Exception('Unknown route: ${settings.name}');
          }

          return MaterialPageRoute<dynamic>(
            builder: (context) {
              return page;
            },
            settings: settings,
          );
        },
      ),
    );
  }
}

/* backup
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
      home: const welcome(), //new login page
      //const loginScreen(), old login page
    );
  }
}
*/