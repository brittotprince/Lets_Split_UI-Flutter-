import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main_screen.dart';
import 'chat_provider.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'chat_screen.dart' as ChatScreen;
import 'bill_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 16.0),
        ),
      ),
      home: BillScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.dashboard),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: ChatScreen.ChatScreen(),
      ),
    );
  }
}
