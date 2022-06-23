import 'dart:async';

import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';

class AudioPlayerMessageNacho extends StatefulWidget {

  const AudioPlayerMessageNacho({ 
    Key? key,
    required this.url
  }) : super(key: key);

  final String url;

  @override
  State<AudioPlayerMessageNacho> createState() => _AudioPlayerMessageNachoState();
}

class _AudioPlayerMessageNachoState extends State<AudioPlayerMessageNacho> {
  
  final player = AudioPlayer();
  Duration? position, duration;
  late List<StreamSubscription> streams;
  PlayerState? state;
  Duration? streamDuration, streamPosition;

  @override
  void initState() {
    super.initState();
    player.setSourceUrl(widget.url);    
    streams = <StreamSubscription>[
      player.onDurationChanged
          .listen((it) => setState(() => streamDuration = it)),
      player.onPlayerStateChanged
          .listen((it) => setState(() => state = it)),
      player.onPositionChanged
          .listen((it) => setState(() => streamPosition = it)),
      player.onPlayerComplete.listen((it) => print('Player complete!')),
      player.onSeekComplete.listen((it) => print('Seek complete!')),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    streams.forEach((it) => it.cancel());
  }

  Future<void> getPosition() async {
    final position = await player.getCurrentPosition();
    setState(() => this.position = position);
  }

  Future<void> getDuration() async {
    final duration = await player.getDuration();
    setState(() => this.duration = duration);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 150,
      child: PlayerWidget(
        player: player,
        duration: duration,
        position: position,
      ),
    );
  }
}


class PlayerWidget extends StatefulWidget {
  final AudioPlayer player;
  final Duration? duration;
  final Duration? position;

  const PlayerWidget({
    Key? key,
    required this.player,
    required this.duration,
    required this.position
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  Duration? _duration;
  Duration? _position;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
    String get _durationText => _duration?.toString().split('.').first ?? '';
  String get _positionText => _position?.toString().split('.').first ?? '';

  AudioPlayer get player => widget.player;

  @override
  void initState() {
    super.initState();
    _duration = widget.duration;
    _position = widget.position;
    _initStreams();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              key: const Key('play_button'),
              onPressed: _isPlaying ? null : _play,
              iconSize: 48.0,
              icon: const Icon(Icons.play_arrow),
              color: Colors.cyan,
            ),
            IconButton(
              key: const Key('pause_button'),
              onPressed: _isPlaying ? _pause : null,
              iconSize: 48.0,
              icon: const Icon(Icons.pause),
              color: Colors.cyan,
            ),
            IconButton(
              key: const Key('stop_button'),
              onPressed: _isPlaying || _isPaused ? _stop : null,
              iconSize: 48.0,
              icon: const Icon(Icons.stop),
              color: Colors.cyan,
            ),
          ],
        ),
        Slider(
          onChanged: (v) {
            final duration = _duration;
            if (duration == null) {
              return;
            }
            final position = v * duration.inMilliseconds;
            player.seek(Duration(milliseconds: position.round()));
          },
          value: (_position != null &&
                  _duration != null &&
                  _position!.inMilliseconds > 0 &&
                  _position!.inMilliseconds < _duration!.inMilliseconds)
              ? _position!.inMilliseconds / _duration!.inMilliseconds
              : 0.0,
        ),
        Text(
          _position != null
              ? '$_positionText / $_durationText'
              : _duration != null
                  ? _durationText
                  : '',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      player.stop();
      setState(() {
        _position = _duration;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        
      });
    });
  }

  Future<void> _play() async {
    final position = _position;
    if (position != null && position.inMilliseconds > 0) {
      await player.seek(position);
    }
    await player.resume();
  }

  Future<void> _pause() async {
    await player.pause();
  }

  Future<void> _stop() async {
    await player.stop();
    setState(() {
      _position = Duration.zero;
    });
  }
}
