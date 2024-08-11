import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/chat');
          },
          child: Text('Go to Chat'),
        ),
      ),
    );
  }
}