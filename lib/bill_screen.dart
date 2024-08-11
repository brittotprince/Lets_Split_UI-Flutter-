import 'package:flutter/material.dart';

class BillScreen extends StatelessWidget {
  final Map<String, dynamic> response = {
    "data": {
      "members": ["Britto", "Vishnu", "Neeraj"],
      "items": [
        {
          "name": "Prawns Biryani",
          "quantity": "1",
          "price": "600",
          "buyers": ["Britto"]
        },
        {
          "name": "Kala Khatta",
          "quantity": "1",
          "price": "135",
          "buyers": ["Neeraj"]
        },
        {
          "name": "Kokum Kadhi",
          "quantity": "1",
          "price": "135",
          "buyers": ["Vishnu"]
        },
        {
          "name": "Bottled Water",
          "quantity": "1",
          "price": "35",
          "buyers": ["Britto", "Vishnu", "Neeraj"]
        },
        {
          "name": "Chicken Pepper Ghee Roast",
          "quantity": "1",
          "price": "495",
          "buyers": ["Neeraj"]
        },
        {
          "name": "Veg Biryani",
          "quantity": "1",
          "price": "380",
          "buyers": ["Vishnu"]
        }
      ],
      "taxes": "88",
      "grandTotal": "1848",
      "offers": "15%"
    }
  };

  @override
  Widget build(BuildContext context) {
    final members = response['data']['members'];
    final items = response['data']['items'];
    final taxes = response['data']['taxes'];
    final offers = response['data']['offers'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(members.join(', ')),
            SizedBox(height: 16),
            Text(
              'Items:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey, width: 1),
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Food Item', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Quantity', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Total Price', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Shared By', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
                ...items.map<TableRow>((item) {
                  return TableRow(
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['name']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['quantity']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['price']),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(item['buyers'].join(', ')),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Discount: $offers',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Taxes: $taxes',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}