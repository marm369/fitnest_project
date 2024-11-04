import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventDetailsPage extends StatefulWidget {
  final Map<String, dynamic> event;
  final LatLng? currentLocation;

  EventDetailsPage({required this.event, required this.currentLocation});

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  List<LatLng> _routeCoordinates = [];
  bool _isRouteLoading = false;

  Future<void> _getRoute(LatLng start, LatLng end) async {
    setState(() {
      _isRouteLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(
          'https://api.openrouteservice.org/v2/directions/driving-car?api_key=5b3ce3597851110001cf6248465d6b0ae5b34c62881034d3a7aada1b&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List coordinates = data['features'][0]['geometry']['coordinates'];

        List<LatLng> routeCoordinates = coordinates.map<LatLng>((coord) {
          return LatLng(coord[1], coord[0]);
        }).toList();

        setState(() {
          _routeCoordinates = routeCoordinates;
          _isRouteLoading = false;
        });

        // Navigate to the route map page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RouteMapPage(
              routeCoordinates: _routeCoordinates,
              eventLocation: end,
              currentLocation: start,
            ),
          ),
        );
      } else {
        throw Exception('Erreur lors de la récupération de l\'itinéraire');
      }
    } catch (e) {
      print('Error fetching route: $e');
      setState(() {
        _isRouteLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la récupération de l\'itinéraire.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    LatLng eventLocation = LatLng(
      widget.event['location']['latitude'],
      widget.event['location']['longitude'],
    );

    return Scaffold(
      appBar: AppBar(title: Text(widget.event['name'])),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event['name'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Date: ${widget.event['date']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Lieu: ${widget.event['location']['address']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Description: ${widget.event['description']}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isRouteLoading
                  ? null
                  : () async {
                if (widget.currentLocation != null) {
                  await _getRoute(widget.currentLocation!, eventLocation);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Localisation actuelle introuvable.')),
                  );
                }
              },
              child: _isRouteLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Voir l\'itinéraire'),
            ),
          ),
        ],
      ),
    );
  }
}

class RouteMapPage extends StatelessWidget {
  final List<LatLng> routeCoordinates;
  final LatLng eventLocation;
  final LatLng currentLocation;

  RouteMapPage({
    required this.routeCoordinates,
    required this.eventLocation,
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Itinéraire')),
      body: FlutterMap(
        options: MapOptions(
          center: currentLocation,
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: eventLocation,
                width: 40,
                height: 40,
                builder: (ctx) => Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              Marker(
                point: currentLocation,
                width: 40,
                height: 40,
                builder: (ctx) => Icon(
                  Icons.person_pin_circle,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ],
          ),
          PolylineLayer(
            polylines: [
              Polyline(
                points: routeCoordinates,
                strokeWidth: 4.0,
                color: Colors.blueAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
