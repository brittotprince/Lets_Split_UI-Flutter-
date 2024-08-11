import 'package:flutter/material.dart';
import 'dart:io';

class AIMessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;

  AIMessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _buildMessageContent(),
      ),
    );
  }

  Widget _buildMessageContent() {
    switch (message['type']) {
      case 'text':
        return Text(message['message']);
      case 'image':
        return Image.file(File(message['imagePath']));
      case 'voice':
        return Icon(Icons.audiotrack, color: Colors.black);
      default:
        return SizedBox.shrink();
    }
  }
}