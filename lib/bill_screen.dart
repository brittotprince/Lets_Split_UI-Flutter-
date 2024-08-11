import 'package:flutter/material.dart';

class BillScreen extends StatefulWidget {
  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Members:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8.0,
                      children: members.map<Widget>((member) {
                        return Chip(
                          label: Text(member),
                        );
                      }).toList(),
                    ),
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
                            title: TextFormField(
                              initialValue: item['name'],
                              decoration: InputDecoration(labelText: 'Food Item'),
                            ),
                            subtitle: TextFormField(
                              initialValue: item['quantity'],
                              decoration: InputDecoration(labelText: 'Quantity'),
                              keyboardType: TextInputType.number,
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextFormField(
                                  initialValue: item['price'],
                                  decoration: InputDecoration(labelText: 'Price'),
                                  keyboardType: TextInputType.number,
                                ),
                                DropdownButtonFormField<String>(
                                  value: item['buyers'].first,
                                  decoration: InputDecoration(labelText: 'Shared By'),
                                  items: members.map<DropdownMenuItem<String>>((String member) {
                                    return DropdownMenuItem<String>(
                                      value: member,
                                      child: Text(member),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      item['buyers'] = [newValue];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    TextFormField(
                      initialValue: offers,
                      decoration: InputDecoration(labelText: 'Discount'),
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      initialValue: taxes,
                      decoration: InputDecoration(labelText: 'Taxes'),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}