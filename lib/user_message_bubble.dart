import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:myapp/bill_screen.dart';
import 'dart:io';

import 'package:myapp/controllers/chat_controller.dart';

class UserMessageBubble extends StatefulWidget {
  final ChatModel chat;

  UserMessageBubble({super.key, required this.chat});

  @override
  State<UserMessageBubble> createState() => _UserMessageBubbleState();
}

class _UserMessageBubbleState extends State<UserMessageBubble> {
  final PlayerController controller = PlayerController();

  void init(String path) async {
    await controller.preparePlayer(
      path: path,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );
  }

  bool isPlaying = false;

  void togglePlaying() {
    if (isPlaying) {
      controller.stopPlayer().then((value) {
        isPlaying = false;
        setState(() {});
      });
    } else {
      controller.startPlayer().then(
        (value) {
          isPlaying = true;
          setState(() {});
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          widget.chat.isAI ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: widget.chat.isAI ? Colors.grey[300] : Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _buildMessageContent(context),
      ),
    );
  }

  Widget _buildMessageContent(BuildContext context) {
    if (widget.chat.image.isNotEmpty) {
      return Image.file(File(widget.chat.image));
    } else if (widget.chat.voice.isNotEmpty) {
      // return const Icon(Icons.audiotrack, color: Colors.white);
      init(widget.chat.voice);
      return Stack(children: [
        AudioFileWaveforms(
          size: Size(MediaQuery.of(context).size.width * 0.5, 36.0),
          playerController: controller,
          enableSeekGesture: true,
          waveformType: WaveformType.long,
          // waveformData: waveformData,
          playerWaveStyle: const PlayerWaveStyle(
            showTop: true,
            fixedWaveColor: Colors.white54,
            liveWaveColor: Colors.blueAccent,
            spacing: 6,
          ),
        ),
        IconButton(
            onPressed: togglePlaying,
            icon: Icon(
              !isPlaying ? Icons.play_arrow : Icons.stop,
              color: Colors.white,
            ))
      ]);
    } else if (widget.chat.text.isNotEmpty) {
      return Text(
        widget.chat.text,
        style: TextStyle(color: Colors.white),
      );
    } else if (widget.chat.response != null) {
      print('${widget.chat.response} DIsplaying  ----');
      // return Text(
      //   "${chat.response?['data']['items']}",
      //   style: TextStyle(color: Colors.white),
      // );
      return BillWidget(response: widget.chat.response ?? {});
    } else {
      return Text('Invalid ChatType SEnd');
    }
  }
}
