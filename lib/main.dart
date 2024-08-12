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