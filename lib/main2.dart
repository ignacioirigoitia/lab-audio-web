import 'package:audio_web/record_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:microphone/microphone.dart';



/// Example app demonstrating how to use the `microphone` plugin and with that
/// a [MicrophoneRecorder].
///
/// The example app listens to realtime updates of the recording and based on
/// that provides functionality to start, stop, and listen to a recording.
class MicrophoneExampleApp extends StatefulWidget {
  /// Constructs [MicrophoneExampleApp].
  const MicrophoneExampleApp({
    Key? key,
    required this.recordingFinishedCallback,
  }) : super(key: key);

  final RecordCallback recordingFinishedCallback;

  @override
  _MicrophoneExampleAppState createState() => _MicrophoneExampleAppState();
}

class _MicrophoneExampleAppState extends State<MicrophoneExampleApp> {
  MicrophoneRecorder? _recorder;
  AudioPlayer? _audioPlayer;

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

  @override
  Widget build(BuildContext context) {
    final value = _recorder?.value;
    Widget result;

    if (value!.started) {
      if (value.stopped) {
        result = GestureDetector(
          onTap: () async {
            _audioPlayer?.dispose();

            _audioPlayer = AudioPlayer();
            final bytes = await _recorder?.toBytes();
            
            // await _audioPlayer?.setUrl(value.recording!.url);
            this.widget.recordingFinishedCallback(value.recording!.url, bytes!, context);
            // await _audioPlayer?.play();
          },
          child: Icon(Icons.send),
        );
      } else {
        result = GestureDetector(
          onTap: () async {
            _recorder?.stop();
          },
          child: Icon(Icons.pause),
        );
      }
    } else {
      result = GestureDetector(
        onTap: () {
          _recorder?.start();
        },
        child: Icon(Icons.mic),
      );
    }

    return result;
  }
}