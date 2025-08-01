import 'package:flutter/material.dart';
import 'package:mecha_connect/parts/order_data.dart';

class Orderscreen extends StatelessWidget {
  const Orderscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Your Orders',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: ordersList.isEmpty
          ? const Center(child: Text('No orders yet.'))
          : ListView.builder(
              itemCount: ordersList.length,
              itemBuilder: (context, index) {
                final item = ordersList[index];
                return Card(
                  color: Colors.white,
                  elevation: 4,
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
                    trailing: Text('₹${item['price'] * item['quantity']}'),
                  ),
                );
              },
            ),
    );
  }
}
