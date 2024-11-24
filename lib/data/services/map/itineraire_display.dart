import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../../configuration/config.dart';

class RouteEvent extends StatefulWidget {
  @override
  _RouteEventState createState() => _RouteEventState();
}

class _RouteEventState extends State<RouteEvent> {
  List<LatLng> _routePoints = [];

  // Coordonnées pour Mohammedia et Rabat
  final LatLng startLocation = LatLng(33.6835, -7.3848); // Mohammedia
  final LatLng destinationLocation = LatLng(34.0209, -6.8417); // Rabat

  @override
  void initState() {
    super.initState();
    _fetchRoute(startLocation, destinationLocation);
  }

  Future<void> _fetchRoute(LatLng start, LatLng destination) async {
    final String url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$ORSAPIKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['features'] != null && data['features'].isNotEmpty) {
          final route = data['features'][0]['geometry']['coordinates'];
          setState(() {
            _routePoints = route
                .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
                .toList();
          });
        } else {
          print('No route found in the response: ${response.body}');
          _showErrorDialog('No route found. Please check the input locations.');
        }
      } else {
        print(
            'Failed to fetch route: ${response.statusCode} - ${response.reasonPhrase}');
        _showErrorDialog('Failed to fetch route: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching route: $e');
      _showErrorDialog('Unable to retrieve route. Please try again later.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route between Mohammedia and Rabat'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: startLocation,
          zoom: 8.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints,
                strokeWidth: 4.0,
                color: Colors.blue,
              ),
            ],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: startLocation,
                builder: (ctx) =>
                    Icon(Icons.location_pin, color: Colors.green, size: 40),
              ),
              Marker(
                point: destinationLocation,
                builder: (ctx) =>
                    Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
