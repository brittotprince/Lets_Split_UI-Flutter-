import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  List<Map<String, String>> _messages = [];

  List<Map<String, String>> get messages => _messages;

  void addMessage(String message, String sender) {
    _messages.add({'message': message, 'sender': sender});
    notifyListeners();
  }
}