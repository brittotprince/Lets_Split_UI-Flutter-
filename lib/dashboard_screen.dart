import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userData = [
    {'name': 'John Doe', 'profilePic': 'assets/profile1.png', 'amount': 120.50},
    {'name': 'Jane Smith', 'profilePic': 'assets/profile2.png', 'amount': 250.75},
    {'name': 'Alice Johnson', 'profilePic': 'assets/profile3.png', 'amount': 300.00},
    // Add more user data here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final user = userData[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user['profilePic']),
              ),
              title: Text(user['name']),
              subtitle: Text('Amount: \$${user['amount']}'),
            ),
          );
        },
      ),
    );
  }
}