import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/chat_controller.dart';
import 'getx_di.dart';
import 'package:provider/provider.dart';
import 'history_screen.dart';
import 'dashboard_screen.dart';
import 'chat_screen.dart' as ChatScreen;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // await GetStorage.init();
  GetXDependencyInjector().onInit();
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final ChatController chatController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let\'s Split AI'),
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
            onPressed: () => chatController.getDashBoard(),
          ),
        ],
      ),
      body: Center(
        child: ChatScreen.ChatScreen(),
      ),
    );
  }
}
