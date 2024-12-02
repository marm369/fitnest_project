import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../events/models/event.dart';
import '../../../data/services/event/event_service.dart';

class EventsMapScreen extends StatefulWidget {
  @override
  _EventsMapScreenState createState() => _EventsMapScreenState();
}

class _EventsMapScreenState extends State<EventsMapScreen> {
  List<Marker> markers = [];
  List<Polyline> polylines = [];
  List<Event> events = [];
  List<LatLng> selectedRouteCoordinates = []; // To store selected event's route

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      events = await EventService().fetchEventsWithDetails();
      setState(() {
        markers = events
            .map((event) {
              // Display the starting point of the route if available, otherwise use location
              final startCoordinate = event.route?.coordinatesFromPath?.first;
              if (startCoordinate != null) {
                // Route is available
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(startCoordinate[1], startCoordinate[0]),
                  builder: (ctx) => GestureDetector(
                    onTap: () => showEventDetails(event),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                );
              } else if (event.location != null) {
                // Route is null but location is available
                return Marker(
                  width: 80.0,
                  height: 80.0,
                  point: LatLng(
                      event.location!.latitude, event.location!.longitude),
                  builder: (ctx) => GestureDetector(
                    onTap: () => showEventDetails(event),
                    child: Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                );
              }
              return null; // Return null if neither route nor location is available
            })
            .whereType<Marker>()
            .toList();
      });
    } catch (e) {
      print("Error fetching events: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load events")),
      );
    }
  }

  void showEventDetails(Event event) {
    // Set the selected route coordinates for the polyline if route is available
    if (event.sportCategory.requiresRoute && event.route != null) {
      selectedRouteCoordinates = event.route!.coordinatesFromPath
          .map((coord) => LatLng(coord[1], coord[0]))
          .toList();

      // Set the polyline for the selected route
      setState(() {
        polylines = [
          Polyline(
            points: selectedRouteCoordinates,
            color: Colors.blue,
            strokeWidth: 4.0,
          ),
        ];
      });
    } else {
      selectedRouteCoordinates = [];
      polylines = [];
    }

    // Show the event details in a dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(event.name ?? "Event Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Description: ${event.description ?? 'No description available'}"),
            Text("Date: ${event.startDate} - ${event.endDate}"),
            Text("Time: ${event.startTime}"),
            Text(
                "Location: ${event.location?.locationName ?? 'Not specified'}"),
            event.imagePath.isNotEmpty
                ? Image.network(event.imagePath)
                : Container(),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                polylines = []; // Clear the polyline when closing the dialog
              });
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Map'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(34.051322, -6.805641), // Default location
          zoom: 10.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: markers,
          ),
          PolylineLayer(
            polylines: polylines,
          ),
        ],
      ),
    );
  }
}
