import 'dart:convert';
import 'dart:typed_data';
import 'package:fitnest/features/events/screens/widgets/event_participants_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:readmore/readmore.dart';
import '../../../common/widgets/chips/sport_category_chip.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../participation/controllers/participation_controller.dart';
import '../../tracking/screens/tracking_organizer_screen.dart';
import '../controllers/event_user_controller.dart';
import '../models/event.dart';
import 'widgets/event_participants_info.dart';
import 'package:http/http.dart' as http;


class EventDetailPage extends StatelessWidget {
  final Event event;
  EventDetailPage({required this.event});
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {

    final EventUserController controller = Get.put(EventUserController());
    controller.fetchUserName(event.organizerId);



    // Fetch the organizer's username
    controller.fetchUserName(event.organizerId);
    // Widget for displaying the image with overlay
    Widget imageWidget;
    try {
      Uint8List imageBytes = base64Decode(event.imagePath);
      imageWidget = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
              gradient: LinearGradient(
                colors: [Colors.black54, Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          // Positioned overlay for event name and details (date, time, location)
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SportCategoryChip(
                      categoryName:
                      event.sportCategory.name, // Pass the category name
                      categoryIcon: iconMapping[event.sportCategory.iconName] ??
                          Icons.sports, // Pass the icon using mapping
                    ),
                  ],
                ),
                Text(
                  utf8.decode(event.name.runes.toList()),
                  style: TextStyle(
                    fontSize: MySizes.fontSizeLg + 2,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: MySizes.spaceBtwItems / 2),
                Text(
                  "Organized By: ${controller.userName.value}",
                  style: TextStyle(
                    fontSize: MySizes.fontSizeSm,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: MySizes.spaceBtwItems / 2),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.white, size: MySizes.iconMd),
                    SizedBox(width: MySizes.spaceBtwItems / 2),
                    Text(
                      "Date: ${event.startDate}",
                      style: TextStyle(
                          color: Colors.white, fontSize: MySizes.fontSizeMd),
                    ),
                    SizedBox(width: MySizes.spaceBtwItems),
                    if (event.location != null)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: MySizes.iconMd),
                          SizedBox(width: MySizes.spaceBtwItems / 2),
                          Text(
                            "${event.location!.locationName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MySizes.fontSizeMd),
                          ),
                        ],
                      )
                  ],
                ),
                SizedBox(height: MySizes.spaceBtwItems / 2),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.white, size: MySizes.iconMd),
                    SizedBox(width: 8),
                    Text(
                      "${event.startTime}",
                      style: TextStyle(
                          fontSize: MySizes.fontSizeMd, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: MySizes.spaceBtwItems / 2),
              ],
            ),
          ),
        ],
      );
    } catch (e) {
      imageWidget = Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        height: 250,
        child: Center(child: Text('Invalid image')),
      );
    }

    // Widget for map or route
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
      // Display location marker if location is not null
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Revenir en arrière
          },
        ),
        title: Text('Event Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageWidget,
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEventInfo(context),
                  SizedBox(height: 16),
                  mapWidget, // Insert map widget here
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildEventInfo(BuildContext context) {
    final ParticipationController participationController = Get.put(ParticipationController());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About Event",
          style: TextStyle(
            fontSize: MySizes.fontSizeLg,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        ReadMoreText(
          event.description,
          style: TextStyle(
            fontSize: MySizes.fontSizeSm,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
            height: 1.5,
          ),
          trimLines: 3,
          colorClickableText: Colors.blue,
          trimCollapsedText: ' Read More',
          trimExpandedText: ' Read Less',
          textAlign: TextAlign.justify,
        ),
        SizedBox(height: MySizes.spaceBtwItems / 2),
        EventParticipantsInfo(
          maxParticipants: event.maxParticipants,
          currentNumParticipants: event.currentNumParticipants,
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        ParticipantsList(
        participants:
        participationController.getParticipationsByEventId(event.id),
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackingScreen(organizerId: event.organizerId,),
            ),
          ),
          child: Text(
            "Track This Event",
            style: TextStyle(
              fontSize: MySizes.fontSizeMd,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
  Future<void> _handleTrackEvent(BuildContext context) async {
    final box = GetStorage();
    final userId = box.read('user_id'); // Replace with actual user ID retrieval logic
    final eventId = event.id;
    final organizerId = event.organizerId;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:8888/api/participations/participants/$eventId'),
      );

      if (response.statusCode == 200) {
        List participants = jsonDecode(response.body);
        bool isParticipant = participants.any((participant) => participant['id'] == userId);
        print("Organizer ID: $organizerId");

        if (!isParticipant) {
          _showDialog(
            context,
            "Not a Participant",
            "You are not a participant in this event.",
          );
          return;
        }

        DateTime eventStartDateTime = DateTime.parse("${event.startDate} ${event.startTime}");
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
              builder: (context) => TrackingScreen(organizerId: event.organizerId),
            ),
          );
        }
      } else {
        _showDialog(context, "Error", "Failed to fetch participants for this event.");
      }
    } catch (e) {
      _showDialog(context, "Error", "An unexpected error occurred: $e");
    }
  }

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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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

}

Widget _buildMapWithRoute(Event event) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: FlutterMap(
      options: MapOptions(
        center: LatLng(
          event.route!.coordinatesFromPath[0][0],
          event.route!.coordinatesFromPath[0][1],
        ),
        zoom: 15.0,
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
      ],
    ),
  );
}

Widget _buildMapWithLocation(Event event) {
  final location = event.location!;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    height: 200,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: FlutterMap(
      options: MapOptions(
        center: LatLng(location.latitude, location.longitude),
        zoom: 15.0,
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
}