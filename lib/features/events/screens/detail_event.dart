import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../common/widgets/chips/sport_category_chip.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../participation/controllers/participation_controller.dart';
import '../controllers/event_user_controller.dart';
import '../models/event.dart';
import 'widgets/event_info.dart';
import 'widgets/event_participants_list.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = HelperFunctions.isDarkMode(context);
    final EventUserController eventUserController =
        Get.put(EventUserController());
    final ParticipationController participationController =
        Get.put(ParticipationController());

    // Fetch the organizer's username
    eventUserController.fetchUserName(event.organizerId);

    Widget imageWidget;
    try {
      Uint8List imageBytes = base64Decode(event.imagePath);
      imageWidget = Stack(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Image.memory(
              imageBytes,
              width: double.infinity,
              height: 400,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: 400,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: Colors.white, size: MySizes.iconMd),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SportCategoryChip(
                  categoryName: event.sportCategory.name,
                  categoryIcon:
                      iconMapping[event.sportCategory.iconName] ?? Icons.sports,
                ),
                const SizedBox(height: MySizes.spaceBtwItems / 2),
                Text(
                  utf8.decode(event.name.runes.toList()),
                  style: TextStyle(
                    fontSize: MySizes.fontSizeLg * 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwItems / 2),
                Obx(() => Text(
                      "Organized By: ${eventUserController.userName.value}",
                      style: TextStyle(
                        fontSize: MySizes.fontSizeSm,
                        color: Colors.white,
                      ),
                    )),
                const SizedBox(height: MySizes.md),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.white, size: MySizes.iconSm),
                    const SizedBox(width: MySizes.spaceBtwItems / 2),
                    Text(
                      "Date: ${event.startDate}",
                      style: TextStyle(
                          color: Colors.white, fontSize: MySizes.fontSizeSm),
                    ),
                  ],
                ),
                if (event.location != null) ...[
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.white, size: MySizes.iconSm),
                      const SizedBox(width: MySizes.spaceBtwItems / 2),
                      Text(
                        "${event.location!.locationName}",
                        style: TextStyle(
                            color: Colors.white, fontSize: MySizes.fontSizeSm),
                      ),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Colors.white, size: MySizes.iconSm),
                      const SizedBox(width: MySizes.spaceBtwItems / 2),
                      Text(
                        "Location: Not available",
                        style: TextStyle(
                            color: Colors.white, fontSize: MySizes.fontSizeSm),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: MySizes.xs),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.white, size: MySizes.iconSm),
                    const SizedBox(width: 8),
                    Text(
                      "${event.startTime}",
                      style: TextStyle(
                          color: Colors.white, fontSize: MySizes.fontSizeSm),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    } catch (e) {
      imageWidget = Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 250,
        child: const Center(
          child: Text('Invalid image', style: TextStyle(color: Colors.white)),
        ),
      );
    }
    Widget mapWidget;
    if (event.sportCategory.requiresRoute && event.route != null) {
      // Display route if requiresRoute is true and route is not null
      mapWidget = Container(
        margin: EdgeInsets.all(16),
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(event.route!.coordinatesFromPath[0][0],
                event.route!.coordinatesFromPath[0][1]),
            zoom: 15.0, // Zoom plus rapproché
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            PolylineLayer(
              polylines: [
                Polyline(
                  points: event.route!.coordinatesFromPath
                      .map((coord) => LatLng(coord[0], coord[1]))
                      .toList(),
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
            MarkerLayer(
              markers: [
                // Marqueur pour le point de départ en rouge
                Marker(
                  point: LatLng(event.route!.coordinatesFromPath[0][0],
                      event.route!.coordinatesFromPath[0][1]),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
                // Marqueur pour le point de destination
                Marker(
                  point: LatLng(event.route!.coordinatesFromPath.last[0],
                      event.route!.coordinatesFromPath.last[1]),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_pin,
                    color: Colors.green,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else if (event.location != null) {
      final location = event.location!;
      mapWidget = Container(
        margin: EdgeInsets.all(16),
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(location.latitude, location.longitude),
            zoom: 15.0, // Zoom plus rapproché
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(location.latitude, location.longitude),
                  width: 80.0,
                  height: 80.0,
                  builder: (ctx) => Icon(
                    Icons.location_pin,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      // Display "Location unavailable" if neither location nor route is available
      mapWidget = Container(
        margin: EdgeInsets.all(16),
        height: 200,
        child: Center(
          child: Text(
            "Location unavailable",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            imageWidget,
            EventInfo(
              eventDescription: event.description,
              maxParticipants: event.maxParticipants,
              currentNumParticipants: event.currentNumParticipants,
            ),
            ParticipantsList(
              participants:
                  participationController.getParticipationsByEventId(event.id),
            ),
            mapWidget,
          ],
        ),
      ),
    );
  }
}

/*
Future<void> _handleTrackEvent(BuildContext context) async {
  final box = GetStorage();
  final userId =
      box.read('user_id'); // Replace with actual user ID retrieval logic
  final eventId = event.id;
  final organizerId = event.organizerId;

  try {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8888/api/participations/participants/$eventId'),
    );

    if (response.statusCode == 200) {
      List participants = jsonDecode(response.body);
      bool isParticipant =
          participants.any((participant) => participant['id'] == userId);
      print("Organizer ID: $organizerId");

      if (!isParticipant) {
        _showDialog(
          context,
          "Not a Participant",
          "You are not a participant in this event.",
        );
        return;
      }

      DateTime eventStartDateTime =
          DateTime.parse("${event.startDate} ${event.startTime}");
      DateTime currentDateTime = DateTime.now();

      if (currentDateTime.isBefore(eventStartDateTime)) {
        _showDialog(
          context,
          "Event Not Started",
          "The event is scheduled to start on ${event.startDate} at ${event.startTime}. Please try again later.",
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TrackingScreen(organizerId: event.organizerId),
          ),
        );
      }
    } else {
      _showDialog(
          context, "Error", "Failed to fetch participants for this event.");
    }
  } catch (e) {
    _showDialog(context, "Error", "An unexpected error occurred: $e");
  }
}
*/
void _showDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.redAccent, // Title color
          ),
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 16.0),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white, // Text color
              backgroundColor: Colors.blue, // Button background
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}
