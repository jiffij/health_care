import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../exts.dart';

class ControlsWidget extends StatefulWidget {
  //
  final Room room;
  final LocalParticipant participant;

  const ControlsWidget(
    this.room,
    this.participant, {
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ControlsWidgetState();
}

class _ControlsWidgetState extends State<ControlsWidget> {
  //
  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;
  MediaDevice? _selectedVideoInput;

  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    participant.addListener(_onChange);
    _subscription = Hardware.instance.onDeviceChange.stream
        .listen((List<MediaDevice> devices) {
      _loadDevices(devices);
    });
    Hardware.instance.enumerateDevices().then(_loadDevices);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    participant.removeListener(_onChange);
    super.dispose();
  }

  LocalParticipant get participant => widget.participant;

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    _selectedVideoInput = _videoInputs?.first;
    setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _unpublishAll() async {
    final result = await context.showUnPublishDialog();
    if (result == true) await participant.unpublishAllTracks();
  }

  bool get isMuted => participant.isMuted;

  void _disableAudio() async {
    await participant.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await participant.setMicrophoneEnabled(true);
  }

  void _disableVideo() async {
    await participant.setCameraEnabled(false);
  }

  void _enableVideo() async {
    await participant.setCameraEnabled(true);
  }

  void _selectAudioOutput(MediaDevice device) async {
    await Hardware.instance.selectAudioOutput(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await Hardware.instance.selectAudioInput(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;
    if (_selectedVideoInput?.deviceId != device.deviceId) {
      await track.switchCamera(device.deviceId);
      _selectedVideoInput = device;
      setState(() {});
    }
  }

  void _toggleCamera() async {
    //
    final track = participant.videoTracks.firstOrNull?.track;
    if (track == null) return;

    try {
      final newPosition = position.switched();
      await track.setCameraPosition(newPosition);
      setState(() {
        position = newPosition;
      });
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }

  void _enableScreenShare() async {
    if (WebRTC.platformIsDesktop) {
      try {
        final source = await showDialog<DesktopCapturerSource>(
          context: context,
          builder: (context) => ScreenSelectDialog(),
        );
        if (source == null) {
          print('cancelled screenshare');
          return;
        }
        print('DesktopCapturerSource: ${source.id}');
        var track = await LocalVideoTrack.createScreenShareTrack(
          ScreenShareCaptureOptions(
            sourceId: source.id,
            maxFrameRate: 15.0,
          ),
        );
        await participant.publishVideoTrack(track);
      } catch (e) {
        print('could not publish video: $e');
      }
      return;
    }
    if (WebRTC.platformIsAndroid) {
      // Android specific
      requestBackgroundPermission([bool isRetry = false]) async {
        // Required for android screenshare.
        try {
          bool hasPermissions = await FlutterBackground.hasPermissions;
          if (!isRetry) {
            const androidConfig = FlutterBackgroundAndroidConfig(
              notificationTitle: 'Screen Sharing',
              notificationText: 'LiveKit Example is sharing the screen.',
              notificationImportance: AndroidNotificationImportance.Default,
              notificationIcon: AndroidResource(
                  name: 'livekit_ic_launcher', defType: 'mipmap'),
            );
            hasPermissions = await FlutterBackground.initialize(
                androidConfig: androidConfig);
          }
          if (hasPermissions &&
              !FlutterBackground.isBackgroundExecutionEnabled) {
            await FlutterBackground.enableBackgroundExecution();
          }
        } catch (e) {
          if (!isRetry) {
            return await Future<void>.delayed(const Duration(seconds: 1),
                () => requestBackgroundPermission(true));
          }
          print('could not publish video: $e');
        }
      }

      await requestBackgroundPermission();
    }
    if (WebRTC.platformIsIOS) {
      var track = await LocalVideoTrack.createScreenShareTrack(
        const ScreenShareCaptureOptions(
          useiOSBroadcastExtension: true,
          maxFrameRate: 15.0,
        ),
      );
      await participant.publishVideoTrack(track);
      return;
    }
    await participant.setScreenShareEnabled(true, captureScreenAudio: true);
  }

  void _disableScreenShare() async {
    await participant.setScreenShareEnabled(false);
    if (Platform.isAndroid) {
      // Android specific
      try {
        //   await FlutterBackground.disableBackgroundExecution();
      } catch (error) {
        print('error disabling screen share: $error');
      }
    }
  }

  void _onTapDisconnect() async {
    final result = await context.showDisconnectDialog();
    if (result == true) await widget.room.disconnect();
  }

  void _onTapUpdateSubscribePermission() async {
    final result = await context.showSubscribePermissionDialog();
    if (result != null) {
      try {
        widget.room.localParticipant?.setTrackSubscriptionPermissions(
          allParticipantsAllowed: result,
        );
      } catch (error) {
        await context.showErrorDialog(error);
      }
    }
  }

  void _onTapSimulateScenario() async {
    final result = await context.showSimulateScenarioDialog();
    if (result != null) {
      print('${result}');
      await widget.room.sendSimulateScenario(
        signalReconnect:
            result == SimulateScenarioResult.signalReconnect ? true : null,
        nodeFailure: result == SimulateScenarioResult.nodeFailure ? true : null,
        migration: result == SimulateScenarioResult.migration ? true : null,
        serverLeave: result == SimulateScenarioResult.serverLeave ? true : null,
        switchCandidate:
            result == SimulateScenarioResult.switchCandidate ? true : null,
      );
    }
  }

  void _onTapSendData() async {
    final result = await context.showSendDataDialog();
    if (result == true) {
      await widget.participant.publishData(
        utf8.encode('This is a sample data message'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _toggleCamera(),
            color: Colors.white,
            tooltip: 'toggle camera',
          ),
          if (participant.isMicrophoneEnabled())
            Container(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  iconColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: Icon(Icons.mic),
                onPressed: _disableAudio,
              ),
            )
          else
              Container(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 159, 59, 52)),
                  iconColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: Icon(Icons.mic_off),
                onPressed: _enableAudio,
              ),
            ),
          if (participant.isCameraEnabled())
            Container(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  backgroundColor: MaterialStatePropertyAll(Colors.green),
                  iconColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: Icon(Icons.videocam),
                onPressed: _disableVideo,
              ),
            )
          else
            Container(
              child: TextButton(
                style: ButtonStyle(
                  shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 159, 59, 52)),
                  iconColor: MaterialStatePropertyAll(Colors.white)
                ),
                child: Icon(Icons.videocam_off),
                onPressed: _enableVideo,
              ),
            ),

          ElevatedButton.icon(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 9.5, horizontal: 20)),
              backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 159, 59, 52)),
              iconSize: MaterialStatePropertyAll(22)
            ),
            onPressed: _onTapDisconnect,
            icon: Icon(Icons.highlight_off),
            label: Text('Leave', style: GoogleFonts.comfortaa(textStyle: TextStyle(color: Colors.white, fontSize: 16)),)
          ),
        ],
      ),
    );
  }
}