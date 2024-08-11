import 'package:flutter/material.dart';
import 'dart:io';

class UserMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  UserMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _buildMessageContent(),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message['type']) {
      case 'text':
        return Text(
          message['message'],
          style: TextStyle(color: Colors.white),
        );
      case 'image':
        return Image.file(File(message['imagePath']));
      case 'voice':
        return Icon(Icons.audiotrack, color: Colors.white);
      default:
        return SizedBox.shrink();
    }
  }
}