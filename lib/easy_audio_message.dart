
import 'package:audio_web/players/seekbar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'players/control_buttons.dart';
import 'players/minimal_audio_player.dart';
import 'services/audio_player_service.dart';

class EasyAudioMessage extends StatefulWidget {
  const EasyAudioMessage({ 
    Key? key,
    required this.url 
  }) : super(key: key);

  final String url;

  @override
  State<EasyAudioMessage> createState() => _EasyAudioMessageState();
}

class _EasyAudioMessageState extends State<EasyAudioMessage> {

  late ConcatenatingAudioSource playlist = ConcatenatingAudioSource(
    children: [ 
      AudioSource.uri(Uri.parse('https://cdn.globalrmm.online/assets/celeste,%20blanca,%20celeste.mp3'))
    ]
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BasicAudioPlayer(playlist: playlist,)
    );
  }
}

class BasicAudioPlayer extends StatelessWidget {
  const BasicAudioPlayer({Key? key, required this.playlist, this.autoPlay = false}) : super(key: key);
  final ConcatenatingAudioSource playlist;
  final bool autoPlay;

  @override
  Widget build(BuildContext context) {
    final _audioPlayer = AudioPlayerService();
    
    return MinimalAudioPlayer(
      audioPlayer: _audioPlayer,
      autoPlay: false,
      playlist: playlist,
      child: Column(
        children: [
          ControlButtons(_audioPlayer.player),
          AudioPlayerSeekBar(audioPlayer: _audioPlayer),
          const SizedBox(height: 8.0),
        ],
      ),
    );
  }
}