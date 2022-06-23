



// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

// import 'package:audio_web/audio_playe_message_nacho.dart';
import 'package:audio_web/audio_playe_message_nacho.dart';
import 'package:audio_web/main2.dart';
import 'package:audio_web/providers/assets_provider.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
// import 'package:universal_html/html.dart';
import 'audio_loading_message.dart';
import 'thread_page.dart';

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {

  void _recordingFinishedCallback(String path, Uint8List bytes, BuildContext context) async {
    // final uri = Uri.parse(path);
    // Uint8List bytes = (await NetworkAssetBundle(Uri.parse(path)).load(path))
    //   .buffer
    //   .asUint8List();
    //   print('bytes: $bytes');
    String fileName = path.split('/').last;
    File file = File(bytes, fileName);
    final extensionFile = 'm4a';
    final path2 = await Provider.of<AssetsProvider>(context, listen: false).generateUrl(
      fileName,
      extensionFile,
      'test-metafans'
    );
    if (path2 != null) {
      await Provider.of<AssetsProvider>(context, listen: false).insertAssetAudio(
        bytes, 
        path2.uploadUrl
      );
    } else {
      print('no se pudo generar url');
    }
    // file.length().then(
      // (fileSize) {
      // print(bytes);
        // StreamChannel.of(context).channel.sendMessage(
        //       Message(
        //         attachments: [
        //           Attachment(
        //             type: 'voicenote',
        //             file: AttachmentFile(
        //               size: file.size,
        //               path: path,
        //               bytes: bytes
        //             ),
        //           )
        //         ],
        //       ),
        //     );
      // },
    // );
  }

  Future<Duration?> getDuration(String url) async {
    final player = AudioPlayer();
    var duration = await player.setUrl(url);
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: const StreamChannelHeader(),
    body: Column(
      children: <Widget>[
        Expanded(
          child: StreamMessageListView(
            threadBuilder: (_, parentMessage) => ThreadPage(
              parent: parentMessage,
            ),
            messageBuilder: (context, details, messages, defaultMessage){
              return defaultMessage.copyWith(
                customAttachmentBuilders: {
                  'voicenote': (context, defaultMessage, attachments) {
                    final url = attachments.first.assetUrl;
                    if (url == null) {
                      return const AudioLoadingMessage();
                    }
                    // return EasyAudioMessage(url: url);
                    return AudioPlayerMessageNacho(
                      // source: AudioSource.uri(Uri.parse(url)),
                      url: 'https://cdn.globalrmm.online/assets/celeste,%20blanca,%20celeste.mp3',
                      // url: url,
                    );
                  }
                },
              );
            },
          ),
        ),
        StreamMessageInput(
          actions: [
            MicrophoneExampleApp(
              recordingFinishedCallback: _recordingFinishedCallback,
            )
          ],
        ),
      ],
    ),
  );
  } 
}