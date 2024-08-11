import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'chat_screen.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        leading: IconButton(
          icon: Icon(Icons.history),
          onPressed: () {
            context.go('/history');
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              context.go('/dashboard');
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).startNewChat();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            },
          ),
        ],
      ),
      body: ChatScreen(),
    );
  }
}