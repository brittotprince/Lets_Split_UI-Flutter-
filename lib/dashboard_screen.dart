import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data = {
    "totalOwesYou": 1045.01,
    "totalYouOwe": 0,
    "netBalance": 1045.01,
    "transactionsPerPerson": {
      "66ba0df565c1d782f22d5e00": {
        "userName": "Neeraj",
        "transactions": {
          "Split": {
            "you_owe": 0,
            "owes_you": 573.94
          }
        }
      },
      "66ba0dfe65c1d782f22d5e03": {
        "userName": "Vishnu",
        "transactions": {
          "Split": {
            "you_owe": 0,
            "owes_you": 471.07
          }
        }
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: data['transactionsPerPerson'].entries.map<Widget>((entry) {
            final userId = entry.key;
            final userData = entry.value;
            final userName = userData['userName'];
            final transactions = userData['transactions'];
            final totalOwesYou = transactions.values.fold(0, (sum, item) => sum + item['owes_you']);
            final totalYouOwe = transactions.values.fold(0, (sum, item) => sum + item['you_owe']);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 2,
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/profile1.jpg'),
                ),
                title: Text(
                  userName,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Text(
                  totalOwesYou > 0
                      ? 'Owes you: ₹$totalOwesYou'
                      : 'You owe: ₹$totalYouOwe',
                  style: TextStyle(
                    color: totalOwesYou > 0 ? Colors.green : Colors.red,
                  ),
                ),
                children: transactions.entries.map<Widget>((transactionEntry) {
                  final groupName = transactionEntry.key;
                  final transaction = transactionEntry.value;
                  return ListTile(
                    title: Text('Group Name: $groupName', style: TextStyle(color: Colors.black)),
                    subtitle: Text(
                      transaction['owes_you'] > 0
                          ? 'Owes you: ₹${transaction['owes_you']}'
                          : 'You owe: ₹${transaction['you_owe']}',
                      style: TextStyle(color: Colors.black54),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}