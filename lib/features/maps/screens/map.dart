import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'event_details_page.dart';
import 'widgets/filters.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Map<String, dynamic>> events = [];
  List<Marker> _markers = [];
  List<LatLng> _routeCoordinates = [];
  LatLng? _currentLocation;
  late final MapController _mapController;
  double _currentZoom = 10.0;
  String? selectedCategory;
  String? selectedDateFilter;
  DateTime? startDate;
  DateTime? endDate;
  String searchQuery = "";
  double? selectedDistance;
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    fetchEvents();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> locateMe() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      print(
          "Current location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
      _mapController.move(
          currentLocation, 15.0); // Move map to current location
      setState(() {
        _currentLocation = currentLocation;
        _currentZoom = 15.0;
        _createMarkers(); // Update markers to include the current location
      });
    } catch (e) {
      print('Error locating user: $e');
    }
  }

  Future<void> fetchEvents() async {
    try {
      String url = 'http://192.168.0.121:8080/api/events';

      // Ajoutez un filtre pour la distance
      String? distanceFilter =
          selectedDistance != null ? selectedDistance!.toString() : null;

      if (selectedCategory != null) {
        url += '/category/$selectedCategory';
      } else {
        // Si aucune catégorie n'est sélectionnée, utilisez l'URL pour récupérer tous les événements
        url = 'http://192.168.0.121:8080/api/events/getAllEvents';
      }

      // Ajoutez le filtre de distance si défini
      if (_currentLocation != null && distanceFilter != null) {
        url +=
            '?latitude=${_currentLocation!.latitude}&longitude=${_currentLocation!.longitude}&distance=${(selectedDistance! * 1000).toString()}';
      }

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List fetchedEvents = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          events = fetchedEvents
              .map((event) => {
                    'name': event['name'],
                    'description': event['description'],
                    'location_name': event['locationName'],
                    'start_date': event['startDate'],
                    'end_date': event['endDate'],
                    'location': {
                      'latitude': event['location']['latitude'],
                      'longitude': event['location']['longitude']
                    }
                  })
              .where((event) => event['name']
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
              .toList();
          _createMarkers();
        });
      } else {
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error fetching events: $e');
      showErrorDialog(
          'Échec de la récupération des événements. Veuillez réessayer.');
    }
  }

  void _pickDateRange() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      fetchEvents(); // Récupérer les événements après la sélection de la date
    }
  }

  void _showEventDialog(Map<String, dynamic> event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailsPage(
          event: event,
          currentLocation: _currentLocation,
        ),
      ),
    );
  }

  void _createMarkers() {
    _markers = events.map((event) {
      return Marker(
        point: LatLng(
            event['location']['latitude'], event['location']['longitude']),
        width: 40.0 * (_currentZoom / 15),
        height: 40.0 * (_currentZoom / 15),
        builder: (ctx) => GestureDetector(
          onTap: () {
            _showEventDialog(event);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple.shade700,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.sports_soccer,
                color: Colors.white,
                size: 20.0 * (_currentZoom / 15),
              ),
            ),
          ),
        ),
      );
    }).toList();

    if (_currentLocation != null) {
      _markers.add(
        Marker(
          point: _currentLocation!,
          width: 40.0 * (_currentZoom / 15),
          height: 40.0 * (_currentZoom / 15),
          builder: (ctx) => Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person_pin_circle,
                color: Colors.white,
                size: 20.0 * (_currentZoom / 15),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Map'),
        actions: [
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: locateMe,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentLocation ?? LatLng(33.701847, -7.359415),
              zoom: _currentZoom,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                setState(() {
                  _currentZoom = position.zoom ?? 10.0;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
              if (_routeCoordinates.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routeCoordinates,
                      color: Colors.blue,
                      strokeWidth: 4.0,
                    ),
                  ],
                ),
            ],
          ),
          // searchBar and filters
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(MySizes.spaceBtwItems),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                    fetchEvents(); // Met à jour les événements selon la recherche
                  },
                  decoration: InputDecoration(
                    hintText: 'Rechercher dans Map...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  ),
                ),
              ),

              // Filtres
              Padding(
                padding: const EdgeInsets.all(MySizes.spaceBtwItems),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Filters(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
