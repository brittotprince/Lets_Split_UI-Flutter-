import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/audio_controller.dart';
import 'controllers/chat_controller.dart';
import 'user_message_bubble.dart';
import 'package:http/http.dart' as http;

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatController chatController = Get.find();
  final AudioController audioController = Get.find();

  bool imageLoading = false;
  bool voiceLoading = false;

  Map jsonBill = Map();

  bool _isRecording = false;
  Map voiceUploadResponse = {};

  @override
  void initState() {
    super.initState();
    // _player = FlutterSoundPlayer();
    // _initializeRecorder();
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: chatController.chatList.value.length,
                itemBuilder: (context, index) => UserMessageBubble(
                    chat: (chatController.chatList.value.reversed
                        .toList())[index]),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: chatController.pickImage,
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  onPressed: audioController.toggleRecording,
                ),
                Spacer(),
                // TextButton(
                //   child: Text('Submit'),
                //   onPressed: () => postExpense(voiceUploadResponse),
                // ),
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
                      chatController.addTextChat(_controller.text);
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
