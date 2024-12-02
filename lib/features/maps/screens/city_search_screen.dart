import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../configuration/config.dart';

class CitySearchMapScreen extends StatefulWidget {
  final String placeName;
  CitySearchMapScreen({required this.placeName});

  @override
  _CitySearchMapScreenState createState() => _CitySearchMapScreenState();
}

class _CitySearchMapScreenState extends State<CitySearchMapScreen> {
  LatLng _currentLocation = LatLng(48.8566, 2.3522); // Default location (Paris)
  MapController _mapController = MapController();
  TextEditingController _searchController = TextEditingController();
  String _locationName = ''; // New variable to store location name

  @override
  void initState() {
    super.initState();
    _searchPlace(widget.placeName);
  }

  Future<void> _searchPlace(String placeName) async {
    var coordinates = await getCoordinatesFromPlaceName(placeName);
    if (coordinates != null) {
      setState(() {
        _currentLocation = coordinates['location'];
        _locationName = coordinates['locationName']; // Save the location name
      });
      _mapController.move(_currentLocation, 15);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Lieu "$placeName" trouvé et affiché sur la carte!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lieu "$placeName" non trouvé.')),
      );
    }
  }

  Future<void> _saveLocation(LatLng location) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              'Emplacement enregistré: ${location.latitude}, ${location.longitude}')),
    );

    Navigator.pop(context, {
      'latitude': location.latitude,
      'longitude': location.longitude,
      'locationName': _locationName, // Return the location name here
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vue sur la carte pour "${widget.placeName}"'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveLocation(_currentLocation),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher une ville',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchPlace(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation,
                zoom: 5,
                onTap: (tapPosition, point) {
                  print(
                      "Tapped location: Latitude: ${point.latitude}, Longitude: ${point.longitude}");
                  setState(() {
                    _currentLocation = point; // Update current location
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation,
                      builder: (ctx) =>
                          Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>?> getCoordinatesFromPlaceName(
    String placeName) async {
  final String url =
      'https://api.openrouteservice.org/geocode/search?text=$placeName&api_key=$ORSAPIKey';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    if (data['features'].isNotEmpty) {
      final latitude = data['features'][0]['geometry']['coordinates'][1];
      final longitude = data['features'][0]['geometry']['coordinates'][0];
      final locationName = data['features'][0]['properties']['label'];
      return {
        'location': LatLng(latitude, longitude),
        'locationName': locationName,
      };
    }
  }
  return null;
}
