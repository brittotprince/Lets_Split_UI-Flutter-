import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controllers/chat_controller.dart';

class BillWidget extends StatelessWidget {
  final Map response;
  final ChatController chatController = Get.find();

  BillWidget({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    final members = response['data']?['members'] ?? [];
    final items = response['data']['items'];
    final taxes = response['data']['taxes'];
    final offers = response['data']['offers'];

    return Padding(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
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
                  IconButton(
                      onPressed: () => chatController.navigateToBillEdit(),
                      icon: const Icon(Icons.edit))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
