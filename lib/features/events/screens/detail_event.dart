import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:readmore/readmore.dart';
import '../../../common/widgets/chips/sport_category_chip.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/icons.dart';
import '../../../utils/constants/sizes.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/event_user_controller.dart';
import '../models/event.dart';
import 'widgets/event_participants_info.dart';

class EventDetailPage extends StatelessWidget {
  final Event event;
  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    print("-----------------event-------------");
    print(event);
    final EventUserController controller = Get.put(EventUserController());
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
                    fontSize: MySizes.fontSizeLg * 2,
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
                    else
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: MySizes.iconMd),
                          SizedBox(width: MySizes.spaceBtwItems / 2),
                          Text(
                            "Location: Not available",
                            style: TextStyle(
                                fontSize: MySizes.fontSizeMd,
                                color: Colors.white),
                          ),
                        ],
                      ),
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
                  _buildEventInfo(),
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

  Widget _buildEventInfo() {
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
      ],
    );
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
}
