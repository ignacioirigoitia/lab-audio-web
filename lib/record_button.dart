import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:microphone/microphone.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

typedef RecordCallback = void Function(String, Uint8List, BuildContext);

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.recordingFinishedCallback,
  }) : super(key: key);

  final RecordCallback recordingFinishedCallback;

  @override
  _RecordButtonState createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {

  MicrophoneRecorder? _recorder;
  AudioPlayer? _audioPlayer;

  bool _isRecording = false;
  // final _audioRecorder = Record();

  @override
  void initState() {
    super.initState();

    _initRecorder();
  }

  @override
  void dispose() {
    _recorder?.dispose();
    _audioPlayer?.dispose();

    super.dispose();
  }

  void _initRecorder() {
    // Dispose the previous recorder.
    _recorder?.dispose();

    _recorder = MicrophoneRecorder()
      ..init()
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> _start() async {
    // try {
    //   if (await _audioRecorder.hasPermission()) {
    //     await _audioRecorder.start();

    //     bool isRecording = await _audioRecorder.isRecording();
    //     setState(() {
    //       _isRecording = isRecording;
    //     });
    //   }
    // } catch (e) {
    //   print(e);
    // }
    _recorder?.start();
  }

  Future<void> _stop(String url) async {
    // final path = await _audioRecorder.stop();

    _recorder?.stop();

    // widget.recordingFinishedCallback(url);

    setState(() => _isRecording = false);
  }

  @override
  Widget build(BuildContext context) {
    final value = _recorder?.value;
    late final IconData icon;
    late final Color? color;
    if (_isRecording) {
      icon = Icons.stop;
      color = Colors.red.withOpacity(0.3);
    } else {
      color = StreamChatTheme.of(context).primaryIconTheme.color;
      icon = Icons.mic;
    }
    return GestureDetector(
      onTap: () {
        _isRecording 
          ? _stop(value!.recording!.url) 
          : _start();
      },
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}
