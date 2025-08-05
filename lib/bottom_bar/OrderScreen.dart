import 'package:flutter/material.dart';
import 'package:mecha_connect/parts/order_data.dart';

class Orderscreen extends StatefulWidget {
  const Orderscreen({super.key});

  @override
  State<Orderscreen> createState() => _OrderscreenState();
}

class _OrderscreenState extends State<Orderscreen> {
  void _cancelOrder(int index) {
    setState(() {
      ordersList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: ordersList.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                final item = ordersList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Image.asset(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('₹${item['price'] * item['quantity']}'),
                        TextButton(
                          onPressed: () => _cancelOrder(index),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}