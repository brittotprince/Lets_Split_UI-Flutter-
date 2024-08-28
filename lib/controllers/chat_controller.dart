import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../bill_edit.dart';
import '../bill_screen.dart';
import '../dashboard_screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatModel {
  final String image;
  final String voice;
  final String text;
  final bool isAI;
  final Map? response;

  ChatModel(
      {this.image = '',
      this.voice = '',
      this.text = '',
      this.isAI = false,
      this.response});
}

class ChatController extends GetxController {
  final chatList = <ChatModel>[].obs;
  Map responseData = {};
  Map jsonBill = {};
  Map voiceUploadResponse = {};
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void addImageChat(String imagePath) {
    ChatModel imageChat = ChatModel(image: imagePath);
    chatList.removeLast();
    chatList.value = [...chatList, imageChat];
  }

  void addVoiceChat(String voicePath) {
    ChatModel imageChat = ChatModel(voice: voicePath);
    chatList.value = [...chatList, imageChat];
  }

  void addResponseChat(Map response) {
    ChatModel responseChat = ChatModel(response: response, isAI: true);
    print('response received: ${response}');
    chatList.removeLast();
    chatList.value = [...chatList, responseChat];
    responseData = response;
    // Get.to(BillWidget(response: response));
  }

  void navigateToBillEdit() => Get.to(BillEditScreen(response: responseData));

  // void goToDashboardScreen() {

  Future<void> getDashBoard() async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://let-s-split-backend.onrender.com/api/v1/user/analytics/66ba4ce80751174cdbe380fc"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
        },
      );

      // Send the request

      if (response.statusCode == 200) {
        print("Upload successful!");

        // Decode the JSON response
        final decodedJson = jsonDecode(response.body);
        // Print the decoded JSON
        print(decodedJson);

        Get.to(DashboardScreen(
          data: decodedJson,
        ));

        // print(json.decode(response));
      } else {
        String responseBody = response.body;

        print("Failed to upload. $responseBody");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void onProcessingData() {
    chatList.value = [...chatList, ChatModel(text: 'Processing data...')];
  }

  void addTextChat(String message) {
    if (message.trim().isEmpty) return;
    chatList.value = [...chatList, ChatModel(text: message)];
  }

  //   Get.to(DashboardScreen(data: data));
  // }

  Future<void> uploadAudio(File audioFile) async {
    try {
      // String fileName = basename(imageFile.path);
      onProcessingData();
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
      jsonBill['data']['payer'] = "66ba4cbb0751174cdbe380f9";
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

        addResponseChat(decodedJson);
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

  Future<void> uploadImage(File imageFile) async {
    try {
      onProcessingData();
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

  Future<void> pickImage() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      print("Asking user for image permission");
      await Permission.storage.request();
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Send imageFile to backend
      await uploadImage(imageFile);
      addImageChat(pickedFile.path);
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
}
