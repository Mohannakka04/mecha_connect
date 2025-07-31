import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';



// Data model for a mechanic
class Mechanic {
  final String name;
  final double lat;
  final double lng;
  final String address;

  Mechanic({required this.name, required this.lat, required this.lng, required this.address});
}

// Main application widget
class MechanicLocatorApp extends StatelessWidget {
  const MechanicLocatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mechanic Locator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: VehicleFormPage(),
    );
  }
}

// Screen 1: The Vehicle Problem Form
class VehicleFormPage extends StatefulWidget {
  const VehicleFormPage({super.key});

  @override
  _VehicleFormPageState createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  String? selectedVehicle;
  final TextEditingController problemController = TextEditingController();
  final List<String> vehicles = ['Bike', 'Car', 'Truck', 'Van','Lorry'];

  void _submitForm() {
    if (selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle type')),
      );
      return;
    }

    final String problem = problemController.text.trim();
    if (problem.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your problem')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MechanicMapScreen(
          vehicle: selectedVehicle!,
          problemDescription: problem,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicle Service Request')),
      body: Container(
        height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image:AssetImage('assets/tr.jpg'),fit: BoxFit.cover )
        ),
        child: Stack(
          children:[ SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Select Your Vehicle:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade400)
                    ),
                    child: DropdownButton<String>(
                      value: selectedVehicle,
                      hint: const Text('Choose vehicle type'),
                      isExpanded: true,
                      underline: const SizedBox(),
                      items: vehicles.map((vehicle) {
                        return DropdownMenuItem(value: vehicle, child: Text(vehicle));
                      }).toList(),
                      onChanged: (value) => setState(() => selectedVehicle = value),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('2. Describe the Problem:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: problemController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: 'e.g., Engine overheating, flat tire, etc.',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _submitForm,
                      child: const Text('Find Nearby Mechanics'),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }
}


// Screen 2: The Map and Mechanic List
class MechanicMapScreen extends StatefulWidget {
  final String vehicle;
  final String problemDescription;

  const MechanicMapScreen({
    super.key,
    required this.vehicle,
    required this.problemDescription,
  });

  @override
  _MechanicMapScreenState createState() => _MechanicMapScreenState();
}

// ## FIX: Added 'with TickerProviderStateMixin' for the AnimationController
class _MechanicMapScreenState extends State<MechanicMapScreen> with TickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _pulseController;

  LatLng _center = const LatLng(17.3850, 78.4867); // Default center (Hyderabad)
  List<Marker> _markers = [];
  bool _isLoading = true;

  final List<Mechanic> mechanics = [
    Mechanic(name: 'Jagadeesh Garage', lat: 17.083489406806656, lng: 82.07386940240158, address: 'ADB Road, Surampalem'),
    Mechanic(name: 'Rithik Motors', lat: 17.083972393398188,  lng: 82.06321806984927, address: 'ADB Road  , Surampalem'),
    Mechanic(name: 'Suresh Car Service', lat: 17.085285033809193,  lng: 82.05186180871164, address: 'Rameswarampeta, Surampalem'),
  ];

  // ## FIX: Merged the two initState methods into one
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    _loadLocationAndMarkers();
  }
  
  // ## FIX: Added dispose method to prevent memory leaks
  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw Exception('Location permissions are denied');
    }
    
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    } 
  }

  Future<void> _loadLocationAndMarkers() async {
    try {
      await _determinePosition();
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      List<Marker> markers = [
        Marker(
          point: userLocation,
          width: 80,
          height: 80,
          child: PulsingMarker(controller: _pulseController), // Requires PulsingMarker class
        ),
      ];

      for (var mechanic in mechanics) {
        markers.add(Marker(
          point: LatLng(mechanic.lat, mechanic.lng),
          width: 80,
          height: 80,
          child: const Icon(Icons.build, color: Colors.teal, size: 30),
        ));
      }

      setState(() {
        _center = userLocation;
        _markers = markers;
        _isLoading = false;
      });
      
      _mapController.move(_center, 14.0);

    } catch (e) {
      if(mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not fetch location: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mechanics for your ${widget.vehicle}')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3,
                  child: FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: _center,
                      initialZoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                        tileProvider: CancellableNetworkTileProvider(),
                      ),
                      MarkerLayer(markers: _markers),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Showing nearby mechanics for: \"${widget.problemDescription}\"",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    itemCount: mechanics.length,
                    itemBuilder: (context, index) {
                      final m = mechanics[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          leading: const Icon(Icons.build_circle_outlined, color: Colors.teal),
                          title: Text(m.name),
                          subtitle: Text(m.address),
                          onTap: () {
                            _mapController.move(LatLng(m.lat, m.lng), 16.0);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ## FIX: Re-added the missing PulsingMarker widget
class PulsingMarker extends StatelessWidget {
  final AnimationController controller;
  const PulsingMarker({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final size = 40.0 * (1.5 - controller.value * 0.5);
        final opacity = 1.0 - controller.value;
        return Stack(alignment: Alignment.center, children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.teal.withOpacity(opacity * 0.5)),
          ),
          const Icon(Icons.person_pin, color: Colors.blue, size: 30),
        ]);
      },
    );
  }
}