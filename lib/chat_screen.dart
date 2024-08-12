import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:myapp/controllers/chat_controller.dart';
import 'package:myapp/user_message_bubble.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final ChatController chatController = Get.find();

  Map jsonBill = Map();

  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _recordedFilePath;
  Map voiceUploadResponse = {};

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    // _player = FlutterSoundPlayer();
    // _initializeRecorder();
    initRecorder();
  }

  // Future<void> _initializeRecorder() async {
  //   await _recorder!.openAudioSession();
  //   // await _player!.openAudioSession();
  // }

  //---------------------- AUDIO RECORDING---------------------

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
      File audioFile = File(_recordedFilePath!);
      uploadAudio(audioFile);
      chatController.addVoiceChat(_recordedFilePath!);
    } else {
      _recordedFilePath = await startRecording();
      print('Recording started. Saving to: $_recordedFilePath');
    }

    setState(() {});
  }

  // --------------------------EnD OF WORKING CODE----------------------------

  Future<void> uploadImage(File imageFile) async {
    try {
      // String fileName = basename(imageFile.path);
      String mimeType =
          lookupMimeType(imageFile.path) ?? 'application/octet-stream';

      // Create Multipart Request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://let-s-split-backend.onrender.com/api/v1/billupload"),
      );

      // Attach the file in the request
      request.files.add(
        http.MultipartFile(
          'image',
          imageFile.readAsBytes().asStream(),
          imageFile.lengthSync(),
          filename: 'fileName',
          contentType: MediaType.parse(mimeType),
        ),
      );

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Upload successful!");

        String responseBody = await response.stream.bytesToString();

        // Decode the JSON response
        final decodedJson = jsonDecode(responseBody);

        jsonBill = decodedJson;
        // Print the decoded JSON
        print(decodedJson);

        // print(json.decode(response));
      } else {
        print("Failed to upload.");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> postExpense(Map body) async {
    try {
      final response = await http.post(
        Uri.parse("https://let-s-split-backend.onrender.com/api/v1/expense"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
        body: jsonEncode(body),
      );

      // Send the request

      if (response.statusCode == 200) {
        print("Upload successful!");

        String responseBody = response.body;

        // Decode the JSON response
        final decodedJson = jsonDecode(responseBody);

        jsonBill = decodedJson;
        // Print the decoded JSON
        print(decodedJson);

        // print(json.decode(response));
      } else {
        String responseBody = response.body;

        print("Failed to upload. $responseBody");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> uploadAudio(File audioFile) async {
    try {
      // String fileName = basename(imageFile.path);
      String mimeType =
          lookupMimeType(audioFile.path) ?? 'application/octet-stream';

      // Create Multipart Request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            "https://let-s-split-backend.onrender.com/api/v1/voiceUpload"),
      );

      // Attach the file in the request
      request.files.add(
        http.MultipartFile(
          'voice',
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: 'bill',
          contentType: MediaType.parse(mimeType),
        ),
      );

      jsonBill['data']['offers'] = "15%";
      jsonBill['data']['payer'] = "66ba4c930751174cdbe380f6";
      jsonBill['data']['members'] = ["9446895197", "7733483452", "944656737"];
      jsonBill['data']['groupId'] = "66ba4e390751174cdbe3810c";

      request.fields['billJson'] = json.encode(jsonBill);

      // Send the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print("Upload successful!");

        String responseBody = await response.stream.bytesToString();

        // Decode the JSON response
        var decodedJson = jsonDecode(responseBody);
        voiceUploadResponse = decodedJson;
        // Print the decoded JSON
        print(decodedJson);

        chatController.addResponseChat(decodedJson);

        // print(json.decode(response));
      } else {
        print("Failed to upload.");
        print(response.statusCode);
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _pickImage() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Asking user for image permission");
      await Permission.storage.request();
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Send imageFile to backend
      uploadImage(imageFile);
      chatController.addImageChat(pickedFile.path);
    }

    // final Uri uri = Uri.parse('http://localhost:3000/api/v1/billupload');
    // final map = <String, dynamic>{};

    // http.Response response = await http.post(
    //   uri,
    //   body: map,
    // );

    // final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   File imageFile = File(pickedFile.path);
    //   // Send imageFile to backend
    // }
  }

  // void _startRecording() async {
  //   final root = await getApplicationDocumentsDirectory();
  //   final recordingPath = '${root.path}';
  //   print(recordingPath);
  //   Map<Permission, PermissionStatus> permissions = await [
  //     Permission.manageExternalStorage,
  //     Permission.audio,
  //     Permission.microphone,
  //   ].request();

  //   bool permissionsGranted =
  //       (permissions[Permission.manageExternalStorage]?.isGranted ?? false) &&
  //           (permissions[Permission.audio]?.isGranted ?? false) &&
  //           (permissions[Permission.microphone]?.isGranted ?? false);

  //   if (permissionsGranted) {
  //     Directory appFolder = Directory(recordingPath);
  //     bool appFolderExists = await appFolder.exists();
  //     if (!appFolderExists) {
  //       final created = await appFolder.create(recursive: true);
  //       print(created.path);
  //     }

  //     Directory tempDir = await getTemporaryDirectory();
  //     String filePath =
  //         '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';

  //     // final filepath =
  //     //     '$recordingPath/${DateTime.now().millisecondsSinceEpoch}.aac';
  //     print(filePath);

  //     // final config = RecordConfig();

  //     await _recorder?.startRecorder(
  //       toFile: filePath,
  //       codec: Codec.aacADTS,
  //     );
  //   } else {
  //     print('Permissions not granted');
  //   }
  // }

  // Future<void> _stopRecording() async {
  //   if (_isRecording) {
  //     await _recorder!.stopRecorder();
  //     setState(() {
  //       _isRecording = false;
  //     });
  //     // Send _audioPath to backend
  //   }
  // }

  // Future<void> _playAudio() async {
  //   if (_audioPath != null) {
  //     await _player!.startPlayer(fromURI: _audioPath);
  //   }
  // }

  @override
  void dispose() {
    _recorder!.closeAudioSession();
    // _player!.closeAudioSession();
    disposeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatController.chatList.value.length,
                itemBuilder: (context, index) => UserMessageBubble(
                    chat: chatController.chatList.value[index]),
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
                  onPressed: _toggleRecording,
                ),
                Spacer(),
                TextButton(
                  child: Text('Submit'),
                  onPressed: () => postExpense(voiceUploadResponse),
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
      ),
    );
  }
}
