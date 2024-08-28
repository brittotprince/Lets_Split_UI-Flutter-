import 'dart:io';

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'chat_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioController extends GetxController {
  final ChatController chatController = Get.find();
  FlutterSoundRecorder? _recorder;
  final isRecording = false.obs;
  String _recordedFilePath = '';

  @override
  void onInit() {
    _recorder = FlutterSoundRecorder();
    initRecorder();
    super.onInit();
  }

  @override
  void onClose() {
    _recorder!.closeAudioSession();
    // _player!.closeAudioSession();
    disposeRecorder();
    super.onClose();
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

    isRecording.value = true;
    return filePath;
  }

  Future<void> stopRecording() async {
    if (_recorder == null || !isRecording.value) return;

    await _recorder!.stopRecorder();
    isRecording.value = false;
  }

  Future<void> disposeRecorder() async {
    if (_recorder != null) {
      await _recorder!.closeAudioSession();
      _recorder = null;
    }
  }

  void toggleRecording() async {
    if (isRecording.value) {
      await stopRecording();
      print('Recording stopped. File saved at: $_recordedFilePath');
      File audioFile = File(_recordedFilePath!);
      chatController.addVoiceChat(_recordedFilePath!);
      chatController.uploadAudio(audioFile);
    } else {
      _recordedFilePath = await startRecording() ?? '';
      print('Recording started. Saving to: $_recordedFilePath');
    }
  }
}
