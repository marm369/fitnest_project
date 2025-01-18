import 'dart:convert';
import 'dart:typed_data';

import 'package:fitnest/data/services/map/search_place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:iconsax/iconsax.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/services/event/event_service.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../events/models/event.dart';
import '../../events/models/event_filters.dart';
import '../../events/screens/detail_event.dart';
import '../../events/screens/widgets/event_participants_info.dart';
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
  String? selectedDistance;
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
          distance: selectedDistance,
          latitude:currentLocation?.latitude,
          longitude:currentLocation?.longitude
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
  void _onDistanceSelected(String? distance) {
    print('distance in on distance selected :$distance');
    setState(() {
      selectedDistance = distance;
    });
    _fetchEvents();
  }
  void _onFiltersApplied(EventFilters filters) {
    setState(() {
      selectedDateFilter = filters.date;
      selectedPartOfDay = filters.time;
      selectedDistance= filters.distance;

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
      body: Column(
        children: [
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
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        if (currentLocation != null)
                          Marker(
                            point: currentLocation!,
                            builder: (ctx) => const Icon(
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
                                      builder: (context) => EventDetailPage(event: event),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                          else if (event.route != null &&
                              event.route!.coordinatesFromPath.isNotEmpty) {
                            final routeCoordinates = event.route!.coordinatesFromPath[0];
                            if (routeCoordinates.length >= 2) {
                              return Marker(
                                point: LatLng(routeCoordinates[0], routeCoordinates[1]),
                                builder: (ctx) => IconButton(
                                  icon: const Icon(Icons.location_on, color: Colors.green),
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

                // Barre de recherche
                Positioned(
                  top: 36,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(14.0),
                    child: TextField(
                      controller: widget._searchController,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un événement ou un lieu',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSubmitted: _searchLocation,
                    ),
                  ),
                ),

                // Filtres sous la barre de recherche
                Positioned(
                  top: 90,
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
                      onDistanceSelected: _onDistanceSelected,
                      latitude: currentLocation?.latitude ?? 0.0,
                      longitude: currentLocation?.longitude ?? 0.0,
                    ),
                  ),
                ),

                // Liste des événements
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: IgnorePointer(
                    ignoring: false,
                    child: _buildEventList(context),
                  ),
                ),

                Positioned(
                  bottom: 160,
                  right: 17,
                  child: FloatingActionButton(
                    onPressed: _locateMe,
                    backgroundColor: Colors.grey,
                    child: const Icon(Icons.my_location),
                    tooltip: 'Locate me',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEventList(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return buildEventCard(event); // Construire chaque carte d'événement
        },
      ),
    );
  }
  Widget buildEventCard(Event event) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 2.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          color: const Color(0xFFE0E0E0), // Couleur de fond appliquée
          width: 300,
          child: SingleChildScrollView( // Permet de scroller en cas de contenu trop grand
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Ligne pour la date et l'heure
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey, size: 14),
                                const SizedBox(width: 6),
                                Text(
                                  event.startDate,
                                  style: const TextStyle(
                                    color: Color(0xFFC49D83),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  event.startTime,
                                  style: const TextStyle(
                                    color: Color(0xFFC49D83),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${event.currentNumParticipants ?? 'No one'} going",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.red, size: 16),
                                GestureDetector(
                                  onTap: () {
                                    if (event.location != null) {
                                      _mapController.move(
                                        LatLng(
                                          event.location!.latitude,
                                          event.location!.longitude,
                                        ),
                                        15.0,
                                      );
                                    } else if (event.route != null &&
                                        event.route!.coordinatesFromPath.isNotEmpty) {
                                      final routeCoordinates = event.route!.coordinatesFromPath[0];
                                      if (routeCoordinates.length >= 2) {
                                        _mapController.move(
                                          LatLng(routeCoordinates[0], routeCoordinates[1]),
                                          15.0,
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "View on Map",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Image et icônes
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                base64Decode(event.imagePath),
                                width: 100,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 6.0),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Action de partage
                                },
                                icon: const Icon(Icons.share, size: 24, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  // Action d'enregistrement
                                },
                                icon: const Icon(Icons.bookmark, size: 24, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}