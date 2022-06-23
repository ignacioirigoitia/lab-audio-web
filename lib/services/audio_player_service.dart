import 'dart:developer';

import 'package:audio_session/audio_session.dart';
import 'package:just_audio/just_audio.dart';

/// An implementation of [AudioPlayer] with [JustAudioBackground] for notification handelding
/// and [AudioSession] to tell the system how to deal with the played audio , it provides a singleton
/// that all widgets can depend on to access the audio Player events and callbacks .
///
class AudioPlayerService {
  late final AudioSession? _session; // initalize before play audio.

  final AudioPlayer _player = AudioPlayer(); // the actual audio player

  AudioPlayer get player => _player;

  /// singleton pattern applied to keep [JustAudioBackground.init()] calls to one .
  /// when the class is first Constructed .
  static final AudioPlayerService _inst = AudioPlayerService._internal();

  AudioPlayerService._internal() {
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {}, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
  }

  factory AudioPlayerService() => _inst;

  /// plays a list of audios given a  [ConcatenatingAudioSource] playlist.
  Future<void> playAudios(ConcatenatingAudioSource _playlist) async {
    // begin a new audio session to tell the system how to deal with this audio player
    _session = await AudioSession.instance;
    
    await _session?.configure(const AudioSessionConfiguration.music());
    try {
      await _player.setAudioSource(_playlist);
      await _player.play();
    } catch (e, stackTrace) {
      // Catch load errors: 404, invalid url ...
      log("Error loading playlist: $e");
      log(stackTrace.toString());
    }
  }

  // MediaItem _getMediaItemFromAudio(Audio audio) => MediaItem(
  //       id: audio.id,
  //       title: audio.title,
  //       album: audio.album,
  //       artist: audio.artist,
  //       genre: audio.genre,
  //       duration: audio.duration,
  //       artUri: audio.image,
  //       playable: audio.playable,
  //       displayTitle: audio.displayTitle,
  //       displaySubtitle: audio.displaySubtitle,
  //       displayDescription: audio.displayDescription,
  //       rating: audio.rating,
  //       extras: audio.extras,
  //     );

  /// adds [List<AudioSource>] to current playlist at the bottom
  void addToPlayList(ConcatenatingAudioSource _playlist, List<AudioSource> list) => _playlist.addAll(list);

  /// inserts [List<AudioSource>] to the current playist at the top while
  /// maintaing the index of current selected item
  void addToPlayListTop(ConcatenatingAudioSource _playlist, List<AudioSource> list) => _playlist.insertAll(0, list);
}
