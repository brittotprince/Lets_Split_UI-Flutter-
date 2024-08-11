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
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: userData.length,
        itemBuilder: (context, index) {
          final user = userData[index];
          return Card(
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(user['profilePic']),
                radius: 30.0,
              ),
              title: Text(
                user['name'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              subtitle: Text(
                'Amount: \$${user['amount']}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.blueAccent,
              ),
              onTap: () {
                // Handle onTap event
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}