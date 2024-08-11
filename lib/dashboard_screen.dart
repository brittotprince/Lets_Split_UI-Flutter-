import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Screen'),
      ),
      body: Center(
        child: Text('Dashboard Data Here'),
      ),
    );
  }
}