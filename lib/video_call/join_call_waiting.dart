import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_login/video_call/pages/connect.dart';
import 'package:livekit_client/livekit_client.dart';
import '../helper/firebase_helper.dart';
import 'exts.dart';
import 'pages/room.dart';

class JoinCallWaiting extends StatefulWidget {
  String DocId;
  String time;
  String? token;

  JoinCallWaiting(this.DocId, this.time, this.token, {Key? key}) : super(key: key);

  @override
  _JoinCallWaitingState createState() =>
      _JoinCallWaitingState(this.DocId, this.time);
}

class _JoinCallWaitingState extends State<JoinCallWaiting> {
  String DocId;
  String time;
  late DatabaseReference databaseReference;
  String _displayText = '';
  bool ready = false;
  StreamSubscription<DatabaseEvent>? listener;

  _JoinCallWaitingState(this.DocId, this.time) {
    final instance = FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://hola-85371-default-rtdb.asia-southeast1.firebasedatabase.app/');
    var ref = instance.ref(DocId);
    databaseReference = ref.child(time);
    start();
  }

  @override
  void dispose() {
    //implement dispose
    if (listener != null) {
      listener!.cancel();
      listener = null;
    }
    super.dispose();
  }

  void start() async {
    //   databaseReference.set({
    //   'ready': 'true'
    // });
    var snapshot = await databaseReference.child('ready').get();
    setState(() {
      ready = snapshot.value == null
          ? false
          : (snapshot.value == "true" ? true : false);
    });
    databaseReference.keepSynced(true);
    listener =
        databaseReference.child('ready').onValue.listen((DatabaseEvent event) {
      // Handle the data change event here.
      setState(() {
        ready = event.snapshot.value == null
            ? false
            : (event.snapshot.value == "true" ? true : false);
        _displayText =
            'Your meeting at $time is ' + (ready ? 'ready' : 'not ready');
      });
      print(ready);
    });
    _displayText =
        'Your meeting at $time is ' + (ready ? 'ready' : 'not ready');
    print(ready);
  }

  Future<void> _connect(BuildContext ctx) async {
    if (!ready) return;
    String roomid;
    if(widget.token == null){
      roomid = this.DocId + getUID();
    }else{
      roomid = widget.token!;
    }
    final token = await getVideoToken(roomid);
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
        token,
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
          _connect(context);
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
