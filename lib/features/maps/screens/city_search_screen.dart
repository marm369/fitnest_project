import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitySearchMapScreen extends StatefulWidget {
  final String placeName;

  CitySearchMapScreen({required this.placeName});

  @override
  _CitySearchMapScreenState createState() => _CitySearchMapScreenState();
}

class _CitySearchMapScreenState extends State<CitySearchMapScreen> {
  LatLng _currentLocation = LatLng(48.8566, 2.3522); // Default location (Paris)
  MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _searchPlace(widget.placeName);
  }

  Future<void> _searchPlace(String placeName) async {
    LatLng? coordinates = await getCoordinatesFromPlaceName(placeName);
    if (coordinates != null) {
      setState(() {
        _currentLocation = coordinates;
      });
      _mapController.move(coordinates, 15); // Zoom closer for specific places
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lieu "$placeName" trouvé et affiché sur la carte!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lieu "$placeName" non trouvé.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vue sur la carte pour "${widget.placeName}"')),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation,
          zoom: 5,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: _currentLocation,
                builder: (ctx) => Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Function to get coordinates from a specific place name
Future<LatLng?> getCoordinatesFromPlaceName(String placeName) async {
  final String url = 'https://nominatim.openstreetmap.org/search?q=$placeName&format=json&limit=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List data = json.decode(response.body);
    if (data.isNotEmpty) {
      final latitude = double.parse(data[0]['lat']);
      final longitude = double.parse(data[0]['lon']);
      return LatLng(latitude, longitude);
    }
  }
  return null;
}
