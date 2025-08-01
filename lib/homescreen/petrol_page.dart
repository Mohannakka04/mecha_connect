import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
// ## STEP 1: Import the new package
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';

void main() {
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const FuelSelectionPage(),
    );
  }
}

class FuelSelectionPage extends StatefulWidget {
  const FuelSelectionPage({super.key});

  @override
  State<FuelSelectionPage> createState() => _FuelSelectionPageState();
}

class _FuelSelectionPageState extends State<FuelSelectionPage>
    with TickerProviderStateMixin {
  String _selectedFuel = 'Petrol';
  bool _isLoading = true;
  String? _locationError; // To store any error message for the UI

  // Fuel states
  double _petrolLitres = 0.5;
  double _petrolRupees = 50.0;
  final double _pricePerLitrePetrol = 100.0;
  double _dieselLitres = 50.0 / 95.0;
  double _dieselRupees = 50.0;
  final double _pricePerLitreDiesel = 95.0;

  late final MapController _mapController;
  late final AnimationController _pulseController;
  LatLng _center = const LatLng(
    16.9934,
    82.2475,
  ); // Default location Surampalem
  final List<Marker> _markers = [];
  bool _showPetrolBunks = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _locationError = null; // Clear previous errors
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled. Please enable it.';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationError = 'Location permissions are denied.';
            _isLoading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationError =
              'Location permissions are permanently denied. Please enable them from settings.';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final newCenter = LatLng(position.latitude, position.longitude);

      if (mounted) {
        _mapController.move(newCenter, 13.0);
        setState(() {
          _center = newCenter;
          _markers.removeWhere((m) => m.key == const Key('currentLocation'));
          _markers.insert(
            0,
            Marker(
              key: const Key('currentLocation'),
              point: _center,
              width: 80,
              height: 80,
              child: PulsingMarker(controller: _pulseController),
            ),
          );
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _locationError = 'Could not fetch location. Showing default.';
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _searchNearbyPetrolBunks() {
    if (_showPetrolBunks) return;

    List<Marker> petrolMarkers = [
      _buildStationMarker(
        const LatLng(17.0990, 81.9820),
        "Indian Oil",
        const Color(0xFF004E8E),
      ),
      _buildStationMarker(
        const LatLng(17.0880, 82.0801),
        "HP Petrol Pump",
        const Color(0xFF007504),
      ),
      _buildStationMarker(
        const LatLng(17.0880, 82.0474),
        "Reliance Fuel",
        const Color(0xFF895200),
      ),
      _buildStationMarker(
        const LatLng(17.0866, 82.0935),
        "BPCL Station",
        const Color(0xFF003967),
      ),
      _buildStationMarker(
        const LatLng(17.0814, 82.1216),
        "Essar Fuel",
        const Color(0xFF008805),
      ),
      _buildStationMarker(
        const LatLng(17.1576, 82.0101),
        "Shell Gas Station",
        const Color(0xFF9B5E02),
      ),
    ];

    setState(() {
      _markers.addAll(petrolMarkers);
      _showPetrolBunks = true;
    });
    _showSnackBar('Showing nearby stations!');
  }

  Marker _buildStationMarker(LatLng point, String stationName, Color color) {
    return Marker(
      point: point,
      width: 40,
      height: 40,
      child: GestureDetector(
        onTap: () => _showStationDetails(point, stationName),
        child: Icon(Icons.local_gas_station, color: color, size: 35),
      ),
    );
  }

  void _showStationDetails(LatLng point, String name) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'Location: ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}',
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _submitOrder() {
    final fuelAmount =
        _selectedFuel == 'Petrol' ? _petrolRupees : _dieselRupees;
    final fuelLitres =
        _selectedFuel == 'Petrol' ? _petrolLitres : _dieselLitres;
    _showSnackBar(
      'Order submitted: ${fuelLitres.toStringAsFixed(2)}L of $_selectedFuel for ₹${fuelAmount.toStringAsFixed(0)}',
    );
  }

  void _updateFromPetrolLitres(double l) => setState(() {
    _petrolLitres = l;
    _petrolRupees = (l * _pricePerLitrePetrol).roundToDouble();
  });
  void _updateFromPetrolRupees(double r) => setState(() {
    _petrolRupees = r;
    _petrolLitres = r / _pricePerLitrePetrol;
  });
  void _updateFromDieselLitres(double l) => setState(() {
    _dieselLitres = l;
    _dieselRupees = (l * _pricePerLitreDiesel).roundToDouble();
  });
  void _updateFromDieselRupees(double r) => setState(() {
    _dieselRupees = r;
    _dieselLitres = r / _pricePerLitreDiesel;
  });

  @override
  void dispose() {
    _mapController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Fuel Finder"),
        centerTitle: true,
        actions: [
         
          IconButton(

            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
            tooltip: 'Refresh Location',
          ),
        ],
      ),
      body: Container(height:double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image:AssetImage('assets/fuelbg.jpg'),fit: BoxFit.cover )
        ),
        child: Stack(
          children: [SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Petrol"),
                                  value: 'Petrol',
                                  groupValue: _selectedFuel,
                                  onChanged:
                                      (v) => setState(() => _selectedFuel = v!),
                                  activeColor: Colors.teal,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: const Text("Diesel"),
                                  value: 'Diesel',
                                  groupValue: _selectedFuel,
                                  onChanged:
                                      (v) => setState(() => _selectedFuel = v!),
                                  activeColor: Colors.teal,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                _selectedFuel == 'Petrol'
                                    ? _buildFuelSliders(
                                      key: const ValueKey('petrol'),
                                      litres: _petrolLitres,
                                      rupees: _petrolRupees,
                                      pricePerLitre: _pricePerLitrePetrol,
                                      onLitresChanged: _updateFromPetrolLitres,
                                      onRupeesChanged: _updateFromPetrolRupees,
                                    )
                                    : _buildFuelSliders(
                                      key: const ValueKey('diesel'),
                                      litres: _dieselLitres,
                                      rupees: _dieselRupees,
                                      pricePerLitre: _pricePerLitreDiesel,
                                      onLitresChanged: _updateFromDieselLitres,
                                      onRupeesChanged: _updateFromDieselRupees,
                                      
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
          
                  if (!_isLoading && !_showPetrolBunks)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: _searchNearbyPetrolBunks,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Find Stations',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: [
                          FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _center,
                              initialZoom: 13.0,
                              onMapReady: _getCurrentLocation,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                userAgentPackageName: 'com.example.app',
                                // ## STEP 2: Use the cancellable tile provider for better performance
                                tileProvider: CancellableNetworkTileProvider(),
                              ),
                              MarkerLayer(markers: _markers),
                            ],
                          ),
                          if (_isLoading)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
          
                          if (_locationError != null)
                            Container(
                              color: Colors.black.withOpacity(0.7),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _locationError!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          Geolocator.openAppSettings();
                                        },
                                        child: const Text('Open Settings'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: _submitOrder,
                      child: const Text(
                        "Proceed to Payment",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          ]
        ),
      ),
    );
  }

  Widget _buildFuelSliders({
    required Key key,
    required double litres,
    required double rupees,
    required double pricePerLitre,
    required ValueChanged<double> onLitresChanged,
    required ValueChanged<double> onRupeesChanged,
  }) {
    return Padding(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          const Divider(),
          Text(
            "Litres: ${litres.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: litres,
            min: 50.0 / pricePerLitre,
            max: 5000.0 / pricePerLitre,
            divisions: 495,
            label: litres.toStringAsFixed(2),
            onChanged: onLitresChanged,
          ),
          Text(
            "Rupees: ₹${rupees.toStringAsFixed(0)}",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Slider(
            value: rupees,
            min: 50,
            max: 5000,
            divisions: 495,
            label: "₹${rupees.toStringAsFixed(0)}",
            onChanged: onRupeesChanged,
          ),
          Text(
            "1 litre = ₹${pricePerLitre.toStringAsFixed(2)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

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
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.teal.withOpacity(opacity * 0.5),
              ),
            ),
            const Icon(Icons.my_location, color: Colors.teal, size: 25),
          ],
        );
      },
    );
  }
}