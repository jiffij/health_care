import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';

import '../exts.dart';
import '../widgets/controls.dart';
import '../widgets/participant.dart';
import '../widgets/participant_info.dart';

class RoomPage extends StatefulWidget {
  //
  final Room room;
  final EventsListener<RoomEvent> listener;

  const RoomPage(
    this.room,
    this.listener, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  //
  ParticipantTrack? selected;
  List<ParticipantTrack> participantTracks = [];
  EventsListener<RoomEvent> get _listener => widget.listener;
  bool get fastConnection => widget.room.engine.fastConnectOptions != null;

  @override
  void initState() {
    super.initState();
    widget.room.addListener(_onRoomDidUpdate);
    _setUpListeners();
    _onRoomDidUpdate();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
      if (!fastConnection) {
        _askPublish();
      }
    });
  }

  @override
  void dispose() {
    // always dispose listener
    (() async {
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      await widget.room.dispose();
    })();
    super.dispose();
  }

  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((_) async {
      WidgetsBindingCompatible.instance
          ?.addPostFrameCallback((timeStamp) => Navigator.pop(context));
    })
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<DataReceivedEvent>((event) {
      String decoded = 'Failed to decode';
      try {
        decoded = utf8.decode(event.data);
      } catch (_) {
        print('Failed to decode: $_');
      }
      context.showDataReceivedDialog(decoded);
    });

  void _askPublish() async {
    final result = await context.showPublishDialog();
    if (result != true) return;
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(true);
    } catch (error) {
      print('could not publish video: $error');
      await context.showErrorDialog(error);
    }
    try {
      await widget.room.localParticipant?.setMicrophoneEnabled(true);
    } catch (error) {
      print('could not publish audio: $error');
      await context.showErrorDialog(error);
    }
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {

    
    

    List<ParticipantTrack> userMediaTracks = [];
    List<ParticipantTrack> screenTracks = [];
    List<ParticipantTrack> otherTracks = [];
    
    for (var participant in widget.room.participants.values) {
      for (var t in participant.videoTracks) {
          userMediaTracks.add(ParticipantTrack(
            participant: participant,
            videoTrack: t.track,
            isScreenShare: false,
          ));
      }
      
      
    }   
    // sort speakers for the grid
    //userMediaTracks.sort((a, b) {
      // loudest speaker first
      // if (a.participant.isSpeaking && b.participant.isSpeaking) {
      //   if (a.participant.audioLevel > b.participant.audioLevel) {
      //     return -1;
      //   } else {
      //     return 1;
      //   }
      // }

      // // last spoken at
      // final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
      // final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

      // if (aSpokeAt != bSpokeAt) {
      //   return aSpokeAt > bSpokeAt ? -1 : 1;
      // }

      // // video on
      // if (a.participant.hasVideo != b.participant.hasVideo) {
      //   return a.participant.hasVideo ? -1 : 1;
      // }

      // joinedAt
      // return a.participant.joinedAt.millisecondsSinceEpoch -
      //     b.participant.joinedAt.millisecondsSinceEpoch;
    //});

    final localParticipantTracks = widget.room.localParticipant?.videoTracks;
    if (localParticipantTracks != null) {
      for (var t in localParticipantTracks) {
          userMediaTracks.add(ParticipantTrack(
            participant: widget.room.localParticipant!,
            videoTrack: t.track,
            isScreenShare: false,
          ));
      }
    }

    if(selected != null) {
      if (userMediaTracks.any((element) => element.participant.sid == selected!.participant.sid) == false) selected = null;
    }

    if (selected != null) {
      otherTracks.add(selected!);
      userMediaTracks.removeWhere((element) => element.participant.sid == selected!.participant.sid);
      otherTracks.addAll(userMediaTracks);
      setState(() {
        participantTracks = otherTracks;
      });
    }
    else {
      setState(() {
        participantTracks = [...screenTracks, ...userMediaTracks];
      });
    }
    
  }

  @override
  Widget build(BuildContext context) { 
    Size size = MediaQuery. of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.black,
        body: Stack(
          children: [
            Column(
          children: [
            Expanded(
                child: participantTracks.isNotEmpty
                    ? Container(
                      padding: EdgeInsets.only(top:size.width*0.03, bottom:size.width*0.03, left:size.width*0.02, right:size.width*0.02),
                      child: ParticipantWidget.widgetFor(participantTracks.first, (){}))
                    : Container()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width*0, vertical: size.width*0.01),
              //color: Colors.black.withOpacity(0.5),
              height: participantTracks.length>1? participantTracks.length==2? size.height * 0.4:size.height * 0.25:0,
              //width: participantTracks.length>1? size.width * 0.3:0,
              child: participantTracks.length>1?
                    participantTracks.length==2? 
                        Center(child: Container(
                          padding: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02, bottom: size.width*0.03),
                          width: size.width,
                          height: size.height,
                          child: ParticipantWidget.widgetFor(participantTracks[1], (){
                            setState(() {
                              ParticipantTrack current = participantTracks[1];
                              participantTracks.removeAt(1);
                              participantTracks.insert(0, current);
                              selected = current;
                            });
                          }
                        )
                ))
              : Center(child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: math.max(0, participantTracks.length - 1),
                itemBuilder: (BuildContext context, int index) => Container(
                  padding: EdgeInsets.only(left: size.width*0.02, right: size.width*0.02, bottom: size.width*0.03),
                  width: size.width *0.6,
                  height: size.height,
                  child: ParticipantWidget.widgetFor(participantTracks[index + 1], (){
                            setState(() {
                              ParticipantTrack current = participantTracks[index+1];
                              participantTracks.removeAt(index+1);
                              participantTracks.insert(0, current);
                              selected = current;
                            });
                          }
                        )
                ),
              )):null,
            ),
            if (widget.room.localParticipant != null)
              SafeArea(
                top: false,
                child:
                    Container(
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(20)),
                        color: Color.fromARGB(255, 44, 43, 43),
                      ),
                      child: ControlsWidget(widget.room, widget.room.localParticipant!),)
              ),
          ],
        ),
        ]
        ,)
      ));
  }
}