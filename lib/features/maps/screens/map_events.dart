import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../events/controllers/event_controller.dart';
import '../../events/models/event.dart';
import '../../events/screens/detail_event.dart';
import '../widgets/filters.dart';

class EventsMapPage extends StatefulWidget {
  @override
  _EventsMapPageState createState() => _EventsMapPageState();
}

class _EventsMapPageState extends State<EventsMapPage> {
  final EventController _eventController = EventController();
  List<Event> _events = []; // List of Event objects
  String? _selectedCategory;
  String? _selectedDateFilter;
  LatLng? _currentLocation;
  final MapController _mapController = MapController(); // Map controller

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _determinePosition();
  }

  void _fetchEvents() async {
    print(
        'Fetching events with category: $_selectedCategory, dateFilter: $_selectedDateFilter');
    try {
      final events = await _eventController.getEvents(
        category: _selectedCategory,
        dateFilter: _selectedDateFilter,
      );
      print("---------dans map:-----------,$events");
      setState(() {
        _events = events;
      });
    } catch (e) {
      print('Error fetching events: $e');
      _showErrorDialog('Error loading events: $e');
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
      _selectedDateFilter = null;
    });
    _fetchEvents();
  }

  void _onFiltersApplied(EventFilters filters) {
    setState(() {
      _selectedDateFilter = filters.date;
      _selectedCategory = null;
    });
    _fetchEvents();
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

  void _locateMe() {
    if (_currentLocation != null) {
      _mapController.move(
          _currentLocation!, 15.0); // Focus and zoom to the location
    } else {
      _showErrorDialog('Current location is not available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Events on the Map'),
        backgroundColor: dark ? Colors.black : Colors.white,
        titleTextStyle: TextStyle(
          color: dark ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      body: Column(
        children: [
          // Search Bar outside of Stack
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for an Event',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {},
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                // The Map
                Positioned.fill(
                  child: FlutterMap(
                    mapController: _mapController, // Attach the map controller
                    options: MapOptions(
                      center: _currentLocation ?? LatLng(34.020882, -6.836455),
                      zoom: 12.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          if (_currentLocation != null)
                            Marker(
                              point: _currentLocation!,
                              builder: (ctx) => Icon(
                                Icons.person_pin_circle,
                                color: Colors.blue,
                                size: 40,
                              ),
                            ),
                          ..._events
                              .map((event) {
                                if (event.location != null) {
                                  final location = event.location!;
                                  return Marker(
                                    point: LatLng(
                                        location.latitude, location.longitude),
                                    builder: (ctx) => IconButton(
                                      icon: Icon(Icons.location_on,
                                          color: Colors.red),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailPage(event: event),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return null;
                                }
                              })
                              .whereType<Marker>()
                              .toList(),
                        ],
                      ),
                    ],
                  ),
                ),
                // Filters Positioned Above the Map
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        // Filter Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2.0),
                          child: Filters(
                            onCategorySelected: _onCategorySelected,
                            onFiltersApplied: _onFiltersApplied,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _locateMe,
        child: Icon(Icons.my_location),
        tooltip: 'Locate Me',
      ),
    );
  }
}
