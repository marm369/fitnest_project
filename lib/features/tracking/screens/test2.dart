import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationTrackingScreen extends StatefulWidget {
  @override
  _LocationTrackingScreenState createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  late LatLng _currentLocation = LatLng(33.684620959645116, -7.380830468995316); // Valeur initiale
  final MapController _mapController = MapController();
  Timer? _simulationTimer;
  bool _isSimulating = false;

  @override
  void initState() {
    super.initState();
    _simulateLocation();
  }

  /// Fonction pour générer des positions intermédiaires entre deux points
  List<LatLng> _generateIntermediatePositions(LatLng start, LatLng end, int steps) {
    List<LatLng> positions = [];
    for (int i = 1; i <= steps; i++) {
      double lat = start.latitude + (end.latitude - start.latitude) * (i / steps);
      double lng = start.longitude + (end.longitude - start.longitude) * (i / steps);
      positions.add(LatLng(lat, lng));
    }
    return positions;
  }

  void _simulateLocation() {
    List<LatLng> mockPositions = [
      LatLng(33.684620959645116, -7.380830468995316),
      LatLng(33.68457480213346, -7.382349389898443),
      LatLng(33.6845652368239, -7.382464343258011),
      LatLng(33.68401002178939, -7.382253614918976),
      LatLng(33.69730394335999, -7.372083336805535),
      LatLng(33.6983743815216, -7.374184132100054),
      LatLng(33.69909087887698, -7.374839422456954),
      LatLng(33.69921794432704, -7.3749826066570705),
    ];

    List<LatLng> allPositions = [];

    // Générer les positions intermédiaires pour un mouvement fluide
    for (int i = 0; i < mockPositions.length - 1; i++) {
      allPositions.add(mockPositions[i]);
      allPositions.addAll(_generateIntermediatePositions(mockPositions[i], mockPositions[i + 1], 10)); // 10 étapes
    }
    allPositions.add(mockPositions.last);

    int index = 0;
    setState(() {
      _isSimulating = true;
    });

    _simulationTimer = Timer.periodic(Duration(milliseconds: 100), (timer) { // 100ms pour un mouvement fluide
      if (index >= allPositions.length) {
        timer.cancel();
        setState(() {
          _isSimulating = false;
        });
        return;
      }

      setState(() {
        _currentLocation = allPositions[index];
      });

      _mapController.move(_currentLocation, _mapController.zoom);

      index++;
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' Event Tracking')),
      body: Column(
        children: [
          // Affichage des coordonnées dans une Card
          Card(
            margin: EdgeInsets.all(10),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Location:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Latitude: ${_currentLocation.latitude.toStringAsFixed(6)}'),
                  Text('Longitude: ${_currentLocation.longitude.toStringAsFixed(6)}'),
                ],
              ),
            ),
          ),

          // Carte de localisation
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation,
                zoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isSimulating
          ? FloatingActionButton(
        onPressed: () {
          _simulationTimer?.cancel();
          setState(() {
            _isSimulating = false;
          });
        },
        child: Icon(Icons.stop),
        backgroundColor: Colors.red,
      )
          : null,
    );
  }
}
