import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String? _audioPath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder!.openAudioSession();
    await _player!.openAudioSession();
    await Permission.microphone.request();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Send imageFile to backend
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecording) {
      _audioPath = '';
      await _recorder!.startRecorder(toFile: 'audio.aac');
      setState(() {
        _isRecording = true;
      });
    }
  }

  Future<void> _stopRecording() async {
    if (_isRecording) {
      await _recorder!.stopRecorder();
      setState(() {
        _isRecording = false;
      });
      // Send _audioPath to backend
    }
  }

  Future<void> _playAudio() async {
    if (_audioPath != null) {
      await _player!.startPlayer(fromURI: _audioPath);
    }
  }

  @override
  void dispose() {
    _recorder!.closeAudioSession();
    _player!.closeAudioSession();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                // Your chat messages here
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.image),
                onPressed: _pickImage,
              ),
              IconButton(
                icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                onPressed: _isRecording ? _stopRecording : _startRecording,
              ),
              IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _playAudio,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter your message',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Send text message to backend
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
