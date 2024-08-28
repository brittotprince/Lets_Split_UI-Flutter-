import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bill_screen.dart';

class BillEditScreen extends StatefulWidget {
  final Map response;

  const BillEditScreen({super.key, required this.response});

  @override
  _BillEditScreenState createState() => _BillEditScreenState();
}

class _BillEditScreenState extends State<BillEditScreen> {
  @override
  Widget build(BuildContext context) {
    final response = widget.response;
    final members = response['data']?['members'] ?? [];
    final items = response['data']?['items'] ?? [];
    final taxes = response['data']?['taxes'] ?? '';
    final offers = response['data']?['offers'] ?? '';
    final grandTotal = response['data']?['grandTotal'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Bill Details'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.back();
          Get.snackbar('', 'Bill details updated ✅');
        },
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Members:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              for (var member in members)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    initialValue: member,
                    decoration: InputDecoration(
                      labelText: 'Member',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        members[members.indexOf(member)] = value;
                      });
                    },
                  ),
                ),
              SizedBox(height: 16),
              Text('Items:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  var item = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          initialValue: item['name'],
                          decoration: InputDecoration(
                            labelText: 'Item Name',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              item['name'] = value;
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          initialValue: item['quantity'],
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              item['quantity'] = value;
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          initialValue: item['price'],
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              item['price'] = value;
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        Text(
                            'Buyers: ${item['buyers'].map((element) => getUserName(element)).join(', ')}'),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: taxes,
                decoration: InputDecoration(
                  labelText: 'Taxes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    response['data']['taxes'] = value;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: offers,
                decoration: InputDecoration(
                  labelText: 'Offers',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    response['data']['offers'] = value;
                  });
                },
              ),
              SizedBox(height: 16),
              Text('Grand Total: \Rs.${grandTotal}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
