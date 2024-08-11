import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  void addMessage(String message, String sender) {
    _messages.add({'type': 'text', 'message': message, 'sender': sender});
    notifyListeners();
  }

  void addImageMessage(String imagePath, String sender) {
    _messages.add({'type': 'image', 'imagePath': imagePath, 'sender': sender});
    notifyListeners();
  }

  void addVoiceMessage(String voicePath, String sender) {
    _messages.add({'type': 'voice', 'voicePath': voicePath, 'sender': sender});
    notifyListeners();
  }
}