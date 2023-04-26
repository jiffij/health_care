import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_login/helper/firebase_helper.dart';
import 'package:simple_login/video_call/pages/connect.dart';
import 'package:livekit_client/livekit_client.dart';
import 'exts.dart';
import 'pages/room.dart';

class StartCall extends StatefulWidget {
  String PatientId;
  String time;

  StartCall(this.PatientId, this.time, {Key? key}) : super(key: key);

  @override
  _StartCallState createState() => _StartCallState(this.PatientId, this.time);
}

class _StartCallState extends State<StartCall> {
  String PatientId;
  String time;
  late DatabaseReference databaseReference;
  String _displayText = '';
  bool ready = false;
  String? token;
  // StreamSubscription<DatabaseEvent>? listener;

  _StartCallState(this.PatientId, this.time) {
    // start();
    _displayText = 'Start my meeting at time $time';
  }

  @override
  void dispose() {
    super.dispose();
  }

  void start(context) async {
    String roomid = getUID() + this.PatientId;
    token = await getVideoToken(roomid);
    final instance = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://hola-85371-default-rtdb.asia-southeast1.firebasedatabase.app/');
    var ref = instance.ref(getUID());
    databaseReference = ref.child(time);
    databaseReference.set({'ready': 'true'});
    print(ready);
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //                 builder: (context) => ConnectPage(token!)),
    // );
    _connect(context);
  }

  Future<void> _connect(BuildContext ctx) async {
    //
    try {
      //create new room
      final room = Room();

      // Create a Listener before connecting
      final listener = room.createListener();

      // Try to connect to the room
      // This will throw an Exception if it fails for any reason.
      await room.connect(
        //server link
        "wss://dr-ust.livekit.cloud",
        //temp token
        token!,
      );
      await Navigator.push<void>(
        ctx,
        MaterialPageRoute(builder: (_) => RoomPage(room, listener)),
      );
    } catch (error) {
      print('Could not connect $error');
      await ctx.showErrorDialog(error);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          _displayText,
          style: TextStyle(fontSize: 24.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          start(context);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 50.0,
          child: Center(
            child: Text('Join call'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
