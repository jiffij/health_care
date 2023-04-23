import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension LKExampleExt on BuildContext {
  //
  Future<bool?> showPublishDialog() => showDialog<bool>(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.2),
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Would you like to enable your Camera & Microphone?'),
          titlePadding: const EdgeInsets.only(left: 35, right: 35, bottom: 15),
          icon: const Icon(Icons.help_outline, size: 50,),
          iconPadding: const EdgeInsets.symmetric(vertical: 20),
          iconColor: Color.fromARGB(255, 136, 202, 98),
          titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black, fontSize: 15), height: 1.5),
          shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
          content: Container(
              //width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.sp,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(ctx, false);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        splashColor: Color.fromARGB(255, 27, 89, 161).withOpacity(0.2),
                        child: Ink(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(color: Color.fromARGB(255, 27, 89, 161))
                          ),
                          child: Text(
                            "No",
                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 27, 89, 161))),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(ctx, true);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        splashColor: Colors.white.withOpacity(0.2),
                        child: Ink(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 27, 89, 161),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          child: Text(
                            "Enable",
                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ]
                  )
                ]
              )
            ),
        ),
      );

  Future<bool?> showUnPublishDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('UnPublish'),
          content:
              const Text('Would you like to un-publish your Camera & Mic ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('YES'),
            ),
          ],
        ),
      );

  Future<void> showErrorDialog(dynamic exception) => showDialog<void>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Error'),
          content: Text(exception.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            )
          ],
        ),
      );

  Future<bool?> showDisconnectDialog() => showDialog<bool>(
        barrierDismissible: false,
        barrierColor: Colors.white.withOpacity(0.2),
        context: this,
        builder: (ctx) => AlertDialog(
          //title: const Text('Disconnect'),
          title: const Text('Are you sure to leave?'),
          titlePadding: const EdgeInsets.only(left: 35, right: 35, bottom: 15),
          icon: const Icon(Icons.error_outline, size: 50,),
          iconPadding: const EdgeInsets.symmetric(vertical: 20),
          iconColor: const Color.fromARGB(255, 235, 120, 112),
          titleTextStyle: GoogleFonts.comfortaa(textStyle: const TextStyle(color: Colors.black, fontSize: 15), height: 1.5),
          shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
          content: Container(
              //width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment: CrossAxisAlignment.sp,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(ctx, false);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        splashColor: Color.fromARGB(255, 27, 89, 161).withOpacity(0.2),
                        child: Ink(
                          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                            border: Border.all(color: Color.fromARGB(255, 27, 89, 161))
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Color.fromARGB(255, 27, 89, 161))),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(ctx, true);
                        },
                        borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        splashColor: Colors.white.withOpacity(0.2),
                        child: Ink(
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 27.0),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 27, 89, 161),
                            borderRadius: BorderRadius.all(Radius.circular(32.0)),
                          ),
                          child: Text(
                            "Leave",
                            style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ]
                  )
                ]
              )
            ),
        ),
      );

  Future<bool?> showReconnectDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Reconnect'),
          content: const Text('This will force a reconnection'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reconnect'),
            ),
          ],
        ),
      );

  Future<void> showReconnectSuccessDialog() => showDialog<void>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Reconnect'),
          content: const Text('Reconnection was successful.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Future<bool?> showSendDataDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Send data'),
          content: const Text(
              'This will send a sample data to all participants in the room'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Send'),
            ),
          ],
        ),
      );

  Future<bool?> showDataReceivedDialog(String data) => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Received data'),
          content: Text(data),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  Future<bool?> showSubscribePermissionDialog() => showDialog<bool>(
        context: this,
        builder: (ctx) => AlertDialog(
          title: const Text('Allow subscription'),
          content: const Text(
              'Allow all participants to subscribe tracks published by local participant?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('NO'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('YES'),
            ),
          ],
        ),
      );

  Future<SimulateScenarioResult?> showSimulateScenarioDialog() =>
      showDialog<SimulateScenarioResult>(
        context: this,
        builder: (ctx) => SimpleDialog(
          title: const Text('Simulate Scenario'),
          children: SimulateScenarioResult.values
              .map((e) => SimpleDialogOption(
                    child: Text(e.name),
                    onPressed: () => Navigator.pop(ctx, e),
                  ))
              .toList(),
        ),
      );
}

enum SimulateScenarioResult {
  signalReconnect,
  nodeFailure,
  migration,
  serverLeave,
  switchCandidate,
  clear,
}