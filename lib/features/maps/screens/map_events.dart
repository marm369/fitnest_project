import 'package:fitnest/data/services/map/search_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/event/event_service.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../events/models/event.dart';
import '../../events/models/event_filters.dart';
import '../../events/screens/detail_event.dart';
import '../widgets/filters.dart';
import 'package:fitnest/features/events/controllers/event_controller_management.dart';
import '../../../configuration/config.dart';

class EventsMapPage extends StatefulWidget {
  final EventControllerManagement eventController =
  EventControllerManagement(eventService: EventService());
  final TextEditingController _searchController = TextEditingController();
  final SearchPlace _mapService = SearchPlace(apiKey: ORSAPIKey);

  EventsMapPage({Key? key}) : super(key: key);

  @override
  _EventsMapPageState createState() => _EventsMapPageState();
}

class _EventsMapPageState extends State<EventsMapPage> {
  String? selectedCategory;
  String? selectedDateFilter;
  String? selectedPartOfDay;
  LatLng? currentLocation;
  final MapController _mapController = MapController();
  List<Event> events = [];
  bool isLoading = false;

  Future<void> _fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    try {
      await widget.eventController.getEvents(
        category: selectedCategory,
        dateFilter: selectedDateFilter,
        partDay: selectedPartOfDay,
      );
      setState(() {
        events = widget.eventController.events;
      });
    } catch (e) {
      print('Error fetching events: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category;
    });
    _fetchEvents();
  }

  void _onPartDaySelected(String? partDay) {
    setState(() {
      selectedPartOfDay = partDay;
    });
    _fetchEvents();
  }

  void _onFiltersApplied(EventFilters filters) {
    setState(() {
      selectedDateFilter = filters.date;
      selectedPartOfDay = filters.time;
    });
    _fetchEvents();
  }

  Future<void> _determinePosition() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        print('Location permission denied.');
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  void _locateMe() {
    if (currentLocation != null) {
      _mapController.move(currentLocation!, 15.0);
    } else {
      print('Current location is not available.');
    }
  }

  Future<void> _searchLocation(String query) async {
    final location = await widget._mapService.getCoordinatesFromAddress(query);
    if (location != null) {
      setState(() {
        currentLocation = LatLng(location.latitude, location.longitude);
      });
      _mapController.move(currentLocation!, 15.0);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location "$query" not found.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
    _fetchEvents();
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = HelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Events on the Map'),
        backgroundColor: darkMode ? Colors.black : Colors.white,
        titleTextStyle: TextStyle(
          color: darkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget._searchController,
              decoration: InputDecoration(
                hintText: 'Search for an Event or Location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onSubmitted: _searchLocation,
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: currentLocation ?? LatLng(34.020882, -6.836455),
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
                        if (currentLocation != null)
                          Marker(
                            point: currentLocation!,
                            builder: (ctx) => Icon(
                              Icons.person_pin_circle,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ...events.map((event) {
                          if (event.location != null) {
                            final location = event.location!;
                            return Marker(
                              point: LatLng(location.latitude, location.longitude),
                              builder: (ctx) => IconButton(
                                icon: const Icon(
                                  Icons.location_on,
                                  color: Colors.red,
                                ),
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
                          }
                          else if (event.route != null && event.route!.coordinatesFromPath.isNotEmpty) {
                            // Vérification des coordonnées dans la route
                            final routeCoordinates = event.route!.coordinatesFromPath[0];
                            if (routeCoordinates.length >= 2) {
                              return Marker(
                                point: LatLng(routeCoordinates[0], routeCoordinates[1]),
                                builder: (ctx) => IconButton(
                                  icon: Icon(Icons.location_on, color: Colors.green),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventDetailPage(event: event),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }
                          }
                          return null;
                        }).whereType<Marker>().toList(),
                      ],
                    ),
                  ],
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Filters(
                      onCategorySelected: (category) {
                        _onCategorySelected(category?.name);
                      },
                      onFiltersApplied: _onFiltersApplied,
                      onPartDaySelected: _onPartDaySelected,
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
        child: const Icon(Icons.my_location),
        tooltip: 'Locate Me',
      ),
    );
  }
}
