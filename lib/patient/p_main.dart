import 'package:flutter/material.dart';

/* Chat
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:provider/provider.dart';

import '../chat/ChatSetup.dart';
*/

// Patient page:
import 'p_homepage.dart';

// Doctor page:
// import 'd_homepage.dart';

/* Chat
const routeHome = '/';
const routePrefixChat = '/chat/';
const routeChatHome = '$routePrefixChat$routeChatChannels';
const routeChatChannels = 'chat_channels';
const routeChatChannel = 'chat_channel';
*/

void main() {
  runApp(const MyApp());
}

/* Chat backup
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
            page = const p_HomePage();
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

// backup
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main page',
      theme: ThemeData(
          // This is the theme of the application.
          ),
      //home: const p_CalendarPage(),
      //home: const p_DoctorListPage(),
      //home: const p_DoctorDetailPage(),
      home: const p_HomePage(),
      //home: const d_HomePage(),
      //home: const p_MyProfilePage(),
    );
  }
}
//