import 'package:flutter/material.dart';
//import 'package:bsnl_home/parts/cart_screen.dart';
import 'package:mecha_connect/parts/cart_screen.dart';

class PartsScreen extends StatefulWidget {
  const PartsScreen({super.key});

  @override
  State<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends State<PartsScreen> {
  final List<String> _vehicleList = ["Bike", "Car", "Other"];
  String? selectedVehicle;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final Map<String, List<Map<String, dynamic>>> allParts = {
    'Bike': [
      {'name': 'Bike Tire', 'image': 'assets/bike tyre.jpg', 'price': 1500},
      {'name': 'Engine Oil', 'image': 'assets/engine oil.png', 'price': 600},
      {'name': 'Brake Pads', 'image': 'assets/break pads.png', 'price': 450},
      {'name': 'Chain Kit', 'image': 'assets/chain kit.png', 'price': 500},
      {'name': 'Clutch Lever', 'image': 'assets/clutch lever.png', 'price': 1300},
      {'name': 'Fuel Tank Cap', 'image': 'assets/fuel tank cap.png', 'price': 400},
    ],
    'Car': [
      {'name': 'Car Battery', 'image': 'assets/battery.png', 'price': 5000},
      {'name': 'Side Mirror', 'image': 'assets/side_mirror.png', 'price': 350},
      {'name': 'Wiper Blades', 'image': 'assets/wipers.png', 'price': 700},
      {'name': 'Gear Knob', 'image': 'assets/gear knob.png', 'price': 500},
      {'name': 'Radiator', 'image': 'assets/radiator.png', 'price': 4000},
    ],
    'Other': [
      {'name': 'Tool Kit', 'image': 'assets/tool kit.png', 'price': 1200},
      {'name': 'Helmet Lock', 'image': 'assets/helmet lock.png', 'price': 250},
      {'name': 'Car Jack', 'image': 'assets/car jack.png', 'price': 1100},
      {'name': 'Dash Camera', 'image': 'assets/Dashboard Camera.png', 'price': 4000},
      {'name': 'GPS Tracker', 'image': 'assets/gps tracker.png', 'price': 3700},
      {'name': 'Spark plug', 'image': 'assets/spark plugs.png', 'price': 400},
    ],
  };

  final List<Map<String, dynamic>> selecttems = [];

  List<Map<String, dynamic>> get spareParts {
    List<Map<String, dynamic>> allItems = [];

    if (selectedVehicle == null) {
      allItems = allParts.values.expand((parts) => parts).toList();
    } else if (allParts.containsKey(selectedVehicle)) {
      allItems = allParts[selectedVehicle]!;
    }

    if (_searchQuery.isEmpty) return allItems;

    return allItems.where((item) =>
      item['name'].toLowerCase().contains(_searchQuery.toLowerCase())).toList();
  }

  void _addtocart(Map<String, dynamic> item) {
    final index = selecttems.indexWhere(
      (element) => element['name'] == item['name'],
    );
    if (index == -1) {
      setState(() {
        selecttems.add({...item, 'quantity': 1});
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${item['name']} added to cart')));
    } else {
      setState(() {
        selecttems[index]['quantity'] += 1;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Increased quantity of ${item['name']}')));
    }
  }

  void _cartScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(
          selecttems: selecttems,
          onRemove: (item) {
            setState(() {
              selecttems.remove(item);
            });
          },
        ),
      ),
    );
  }

  void _resetDropdown() {
    setState(() {
      selectedVehicle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Spare Parts'),
        actions: [
          Stack(
            children: [
              IconButton(
                onPressed: _cartScreen,
                icon: const Icon(Icons.shopping_cart),
              ),
              if (selecttems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${selecttems.length}',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Select your vehicle",
                      hintText: "All Vehicles",
                    ),
                    value: selectedVehicle,
                    items: _vehicleList
                        .map((vehicle) => DropdownMenuItem(
                              value: vehicle,
                              child: Text(vehicle),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  onPressed: _resetDropdown,
                  icon: const Icon(Icons.clear),
                  tooltip: 'Clear selection',
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search spare parts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: spareParts.isEmpty
                  ? const Center(child: Text('No spare parts available.'))
                  : GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.75,
                      children: spareParts.map((part) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.vertical(top: Radius.circular(12)),
                                  child: Image.asset(
                                    part['image'],
                                    height: 50,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      part['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          '₹${part['price']}',
                                          style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => _addtocart(part),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12, vertical: 6),
                                          ),
                                          child: const Text('Add'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}