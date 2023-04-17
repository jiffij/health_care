import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class JoinCallWaiting extends StatefulWidget {
  String DocId;
  String time;

  JoinCallWaiting(this.DocId, this.time, {Key? key}) : super(key: key);

  @override
  _JoinCallWaitingState createState() =>
      _JoinCallWaitingState(this.DocId, this.time);
}

class _JoinCallWaitingState extends State<JoinCallWaiting> {
  String DocId;
  String time;
  late DatabaseReference databaseReference;
  String _displayText = 'Hello, world!';
  bool ready = false;

  _JoinCallWaitingState(this.DocId, this.time) {
    var ref = FirebaseDatabase.instance.ref(DocId);
    databaseReference = ref.child(time);
    start();
  }

  void start() async {
    var snapshot = await databaseReference.get();
    setState(() {
      ready = (snapshot.value ?? false) as bool;
    });
    databaseReference.keepSynced(true);
    databaseReference.onValue.listen((DatabaseEvent event) {
      // Handle the data change event here.
      setState(() {
        ready = (event.snapshot.value ?? false) as bool;
      });
    });
  }

  void _joinCall() {
    //TODO
    if (ready == false) return;
    setState(() {
      _displayText = 'Button pressed!';
    });
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
        onPressed: _joinCall,
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
