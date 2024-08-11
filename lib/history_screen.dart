import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> chatHistory = [
    {'id': 1, 'title': 'Chat with AI - 01', 'lastMessage': 'Hello!'},
    {'id': 2, 'title': 'Chat with AI - 02', 'lastMessage': 'How can I help you?'},
    {'id': 3, 'title': 'Chat with AI - 03', 'lastMessage': 'Goodbye!'},
    // Add more chat sessions here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History'),
      ),
      body: ListView.builder(
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          final chat = chatHistory[index];
          return ListTile(
            title: Text(chat['title']),
            subtitle: Text(chat['lastMessage']),
            onTap: () {
              // Navigate to the chat screen with the selected chat session
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatId: chat['id']),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final int chatId;

  ChatScreen({required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Session $chatId'),
      ),
      body: Center(
        child: Text('Chat content for session $chatId'),
      ),
    );
  }
}