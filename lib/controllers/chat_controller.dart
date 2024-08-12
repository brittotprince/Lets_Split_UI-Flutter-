import 'package:get/get.dart';
import 'package:myapp/bill_edit.dart';
import 'package:myapp/bill_screen.dart';

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
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  final chatList = <ChatModel>[].obs;
  Map responseData = {};

  void addImageChat(String imagePath) {
    ChatModel imageChat = ChatModel(image: imagePath);
    chatList.value = [...chatList, imageChat];
  }

  void addVoiceChat(String voicePath) {
    ChatModel imageChat = ChatModel(voice: voicePath);
    chatList.value = [...chatList, imageChat];
  }

  void addResponseChat(Map response) {
    ChatModel responseChat = ChatModel(response: response, isAI: true);
    print('response received: ${response}');
    chatList.value = [...chatList, responseChat];
    responseData = response;
    // Get.to(BillWidget(response: response));
  }

  void navigateToBillEdit() => Get.to(BillEditScreen(response: responseData));
}
