import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Map<String, dynamic> data = {
    "totalOwesYou": 1045.01,
    "totalYouOwe": 0,
    "netBalance": 1045.01,
    "transactionsPerPerson": {
      "66ba0df565c1d782f22d5e00": [
        {
          "userName": "Neeraj",
          "owes_you": 0,
          "you_owe": 573.94,
          "groupName": "Split"
        }
      ],
      "66ba0dfe65c1d782f22d5e03": [
        {
          "userName": "Vishnu",
          "owes_you": 0,
          "you_owe": 471.07,
          "groupName": "Split"
        }
      ]
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: ListView(
        children: data['transactionsPerPerson'].entries.map<Widget>((entry) {
          final userId = entry.key;
          final transactions = entry.value;
          final userName = transactions[0]['userName'];
          final totalOwesYou = transactions.fold(0, (sum, item) => sum + item['owes_you']);
          final totalYouOwe = transactions.fold(0, (sum, item) => sum + item['you_owe']);

          return ExpansionTile(
            title: Text(userName),
            subtitle: Text(
              totalOwesYou > 0
                  ? 'Owes you: ₹$totalOwesYou'
                  : 'You owe: ₹$totalYouOwe',
              style: TextStyle(
                color: totalOwesYou > 0 ? Colors.green : Colors.red,
              ),
            ),
            children: transactions.map<Widget>((transaction) {
              return ListTile(
                title: Text(transaction['groupName']),
                subtitle: Text(
                  transaction['owes_you'] > 0
                      ? 'Owes you: ₹${transaction['owes_you']}'
                      : 'You owe: ₹${transaction['you_owe']}',
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}