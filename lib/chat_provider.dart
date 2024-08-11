import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatProvider with ChangeNotifier {
  List<Map<String, dynamic>> _messages = [];
  
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse('http://localhost:3000/messages'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      _messages = data.map((item) => item as Map<String, dynamic>).toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String message, String sender) async {
    // Simulate a successful API response
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    //     final response = await http.post(
    //   Uri.parse('http://localhost:3000/messages'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({'message': message, 'sender': sender}),
    // );
    // if (response.statusCode == 201) {
    _messages.add({'type': 'text', 'message': message, 'sender': sender});
    notifyListeners();
    //   } else {
    //   throw Exception('Failed to send message');
    // }
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