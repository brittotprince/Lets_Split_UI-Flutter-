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
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
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
                Divider(height: 32, thickness: 2),
                Text(
                  'Items:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                ...items.map<Widget>((item) {
                  return Column(
                    children: [
                      ListTile(
                        title: Text(item['name']),
                        subtitle: Text('Quantity: ${item['quantity']}'),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Price: ₹${item['price']}'),
                            Text('Shared By: ${item['buyers'].join(', ')}'),
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                }).toList(),
                SizedBox(height: 16),
                Text(
                  'Discount: $offers',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Taxes: ₹$taxes',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}