// import 'dart:html';
import 'package:flutter/material.dart';
import 'package:simple_login/video_call/pages/connect.dart';
import 'package:simple_login/welcome.dart';
import 'package:simple_login/yannie_version/pages/yannie_welcome.dart';
import 'login_screen.dart';
// import 'home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Chat - Authentication
import 'package:cloud_functions/cloud_functions.dart';
// Chat - Authentication

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
// Chat - Authentication
FirebaseFunctions functions = FirebaseFunctions.instance;
// Chat - Authentication
final GoogleSignIn _googleSignIn = GoogleSignIn();

// Test 2
void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // binding with plugin with flutter engine
  await Firebase.initializeApp(); // make sure firebase is init

  final client = StreamChatClient(
    '4kvevaagmggn',
    logLevel: Level.OFF,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return StreamChat(client: client, child: child);
      },
      home: const welcome2(),
    );
  }
}
// Test 2

// Test 1
/*
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
            page = const welcome2();
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
*/

/* backup - Old
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
      home: const welcome2(),  //new login page
            //const loginScreen(), old login page
    );
  }
}
*/
