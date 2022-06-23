// import 'dart:async';
// import 'dart:math';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/cupertino.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

// class AudioPlayerMessage extends StatefulWidget {
//   const AudioPlayerMessage({
//     Key? key,
//     // required this.source,
//     required this.id,
//     required this.url
//   }) : super(key: key);

//   // final AudioSource source;
//   final String id;
//   final String url;

//   @override
//   AudioPlayerMessageState createState() => AudioPlayerMessageState();
// }

// class AudioPlayerMessageState extends State<AudioPlayerMessage> {
//   // var audioPlayer = AudioPlayer();
//   late StreamSubscription<PlayerState> _playerStateChangedSubscription;

//   // late Future<Duration?> futureDuration;

//   @override
//   void initState() {
//     super.initState();
    
//     // _playerStateChangedSubscription =
//     //     _audioPlayer.playerStateStream.listen(playerStateListener);
//     // futureDuration = _audioPlayer.setAudioSource(widget.source);
    
//     audioPlayer = AudioCache(
//       fixedPlayer: AudioPlayer(),
//     );

//     Random rnd;
//     int min = -1000;
//     int max = 1000;
//     rnd = new Random();
//     List<double> listaEnteros = [];
//     for (var i = 0; i < 200; i++) {
//       listaEnteros.add(min + rnd.nextInt(max - min) + rnd.nextDouble());
//     }

//     samples = listaEnteros;
//     maxDuration = const Duration(milliseconds: 1000);
//     elapsedDuration = const Duration();
//     parseData();
//     audio.onPlayerCompletion.listen((_) {
//       setState(() {
//         elapsedDuration = maxDuration - Duration(milliseconds: 100);
//       });
//     });
//     audio.onAudioPositionChanged.listen((Duration timeElapsed) {
//       setState(() {
//         elapsedDuration = timeElapsed;
//       });
//     });
//   }
//   var audio = AudioPlayer();

//   void playerStateListener(PlayerState state) async {
//     // if (state.processingState == ProcessingState.completed) {
//     //   await reset();
//     // }
//   }

//   late Duration maxDuration;
//   late AudioCache audioPlayer;
//   bool isPlaying = false;
//   late List<double> samples;
//   late Duration elapsedDuration;

//   Future<void> parseData() async {
//     // maxDuration in milliseconds
//     await Future.delayed(const Duration(milliseconds: 200));
//     await audio.setUrl(widget.url);
//     // final durationAudio2 = await _audioPlayer.getDuration();

//     final durationAudio2 = await Future.delayed(
//       const Duration(seconds: 2),
//       () => audio.getDuration(),
//     );

//     print(durationAudio2);
//     maxDuration = Duration(milliseconds: durationAudio2);
//   }

//   @override
//   void dispose() {
//     _playerStateChangedSubscription.cancel();
//     audio.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Duration?>(
//       // future: futureDuration,
//       builder: (context, snapshot) {
//         // if (snapshot.hasData) {
//           return Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               _controlButtons(),
//               _slider(maxDuration),
//               // _slider(Duration(seconds: 12))
//             ],
//           );
//         // }
//         // return const AudioLoadingMessage();
//       },
//     );
//   }

//   Widget _controlButtons() {
//     return StreamBuilder<bool>(
//       // stream: _audioPlayer.playingStream,
//       builder: (context, _) {
//         final color =
//             isPlaying ? Colors.red : Colors.blue;
//         final icon =
//             isPlaying ? Icons.pause : Icons.play_arrow;
//         return Padding(
//           padding: const EdgeInsets.all(4.0),
//           child: GestureDetector(
//             onTap: () {
//               if (isPlaying) {
//                 pause();
//               } else {
//                 play();
//               }
//             },
//             child: SizedBox(
//               width: 40,
//               height: 40,
//               child: Icon(icon, color: color, size: 30),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _slider(Duration? duration) {
//     return StreamBuilder<Duration>(
      
//       builder: (context, snapshot) {
//         return Container(
//             height: 140,
//             width: 250,
//             child: Container(
//                 padding: EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     color: Colors.grey.shade200),
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       PolygonWaveform(
//                           style: PaintingStyle.stroke,
//                           samples: samples,
//                           height: 60,
//                           width: 300,
//                           maxDuration: maxDuration,
//                           elapsedDuration: elapsedDuration)
//                     ])));
//         // if (snapshot.hasData && duration != null) {
//           // return CupertinoSlider(
//           //   value: _audioPlayer.getDuration(),
//           //   onChanged: (val) {
//           //     _audioPlayer.seek(duration * val);
//           //   },
//           // );
//         // } else {
//         //   return const SizedBox.shrink();
//         // }
//     });
//   }

//   Future<void> play() async {
//     setState(() {
//       isPlaying = false;
//     });
//     // audioPlayer
//     audio.play(widget.url);
//   }

//   Future<void> pause() {
//     setState(() {
//       isPlaying = true;
//     });
//     return audio.pause();
//   }

//   // Future<void> reset() async {
//   //   await _audioPlayer.stop();
//   //   return _audioPlayer.seek(const Duration(milliseconds: 0));
//   // }
// }