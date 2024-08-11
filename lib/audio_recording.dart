import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AudioRecorderScreen(),
    );
  }
}

class AudioRecorderScreen extends StatefulWidget {
  @override
  _AudioRecorderScreenState createState() => _AudioRecorderScreenState();
}

class _AudioRecorderScreenState extends State<AudioRecorderScreen> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    disposeRecorder();
    super.dispose();
  }

  Future<bool> requestPermissions() async {
    var status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openAudioSession();
    await requestPermissions();
  }

  Future<String?> startRecording() async {
    if (_recorder == null) {
      await initRecorder();
    }

    Directory tempDir = await getTemporaryDirectory();
    String filePath =
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: filePath,
      codec: Codec.aacADTS,
    );

    _isRecording = true;
    return filePath;
  }

  Future<void> stopRecording() async {
    if (_recorder == null || !_isRecording) return;

    await _recorder!.stopRecorder();
    _isRecording = false;
  }

  Future<void> disposeRecorder() async {
    if (_recorder != null) {
      await _recorder!.closeAudioSession();
      _recorder = null;
    }
  }

  void _toggleRecording() async {
    if (_isRecording) {
      await stopRecording();
      print('Recording stopped. File saved at: $_recordedFilePath');
    } else {
      _recordedFilePath = await startRecording();
      print('Recording started. Saving to: $_recordedFilePath');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Audio Recorder')),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleRecording,
          child: Text(_isRecording ? 'Stop Recording' : 'Start Recording'),
        ),
      ),
    );
  }
}
