import 'package:flutter/material.dart';
import 'package:mecha_connect/parts/order_data.dart';

class CartScreen extends StatefulWidget {
  final List<Map<String, dynamic>> selecttems;
  final Function(Map<String, dynamic>) onRemove;

  const CartScreen({
    super.key,
    required this.selecttems,
    required this.onRemove,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void _removeItem(Map<String, dynamic> item) {
    setState(() {
      widget.selecttems.remove(item);
    });
    widget.onRemove(item);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item['name']} removed from cart')),
    );
  }

  double get totalPrice {
    double total = 0;
    for (var item in widget.selecttems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }
    return total;
  }

  void _showConfirmation() async {
    ordersList.addAll(widget.selecttems.map((item) => Map<String, dynamic>.from(item)));

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          color: Colors.white,
          
          height: 400,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 12),
              Text(
                'Your order has been placed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      widget.selecttems.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Cart Items',style: TextStyle(fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.selecttems.isEmpty
                ? const Center(child: Text('Your cart is empty.'))
                : ListView.builder(
                    itemCount: widget.selecttems.length,
                    itemBuilder: (context, index) {
                      final item = widget.selecttems[index];
                      return Card(
                        color: Colors.white,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                          title: Text(item['name']),
                          subtitle: Text('₹${item['price']} x ${item['quantity']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    if (item['quantity'] > 1) {
                                      item['quantity']--;
                                    } else {
                                      _removeItem(item);
                                    }
                                  });
                                },
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  setState(() {
                                    item['quantity']++;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (widget.selecttems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('₹${totalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade50
                      ),
                      onPressed: _showConfirmation,
                      child: const Text('Buy Now'),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
