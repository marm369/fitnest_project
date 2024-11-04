import 'dart:async';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import 'route_map_page.dart';

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
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        _showErrorDialog('Location permission is denied.');
      }
    } catch (e) {
      print('Error getting current location: $e');
      _showErrorDialog('Unable to retrieve current location.');
    }
  }

  Future<void> _getRoute(LatLng start, LatLng end) async {
    setState(() {
      _isRouteLoading = true;
    });

    print('Calling _getRoute with start: $start, end: $end');

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
        throw Exception('Failed to retrieve route: ${response.statusCode}');
      }
    } catch (e) {
      print('Error retrieving route: $e');
      setState(() {
        _isRouteLoading = false;
      });

      _showErrorDialog('Failed to retrieve route.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                  'Start Date: ${widget.event['start_date']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'End Date: ${widget.event['end_date']}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Location: ${widget.event['location_name']}',
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
                      if (_currentLocation != null) {
                        await _getRoute(_currentLocation!, eventLocation);
                      } else {
                        _showErrorDialog('Current location not found.');
                      }
                    },
              child: _isRouteLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('View Route'),
            ),
          ),
        ],
      ),
    );
  }
}
