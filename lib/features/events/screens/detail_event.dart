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
    final dark = HelperFunctions.isDarkMode(context);
    final EventUserController eventUserController =
        Get.put(EventUserController());
    final ParticipationController participationController =
        Get.put(ParticipationController());
    eventUserController.fetchUserName(event.organizerId);
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
          Positioned(
            bottom: 330,
            left: 5,
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
                Row(
                  children: [
                    SportCategoryChip(
                      categoryName: event.sportCategory.name,
                      categoryIcon: iconMapping[event.sportCategory.iconName] ??
                          Icons.sports,
                    ),
                  ],
                ),
                Text(
                  utf8.decode(event.name.runes.toList()),
                  style: TextStyle(
                    fontSize: MySizes.fontSizeLg * 1.5,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: MySizes.spaceBtwItems / 2),
                Text(
                  "Organized By: ${eventUserController.userName.value}",
                  style: TextStyle(
                    fontSize: MySizes.fontSizeSm,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: MySizes.md),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: Colors.white, size: MySizes.iconSm),
                    SizedBox(width: MySizes.spaceBtwItems / 2),
                    Text(
                      "Date: ${event.startDate}",
                      style: TextStyle(
                          color: Colors.white, fontSize: MySizes.fontSizeSm),
                    ),
                    SizedBox(width: MySizes.spaceBtwItems),
                    if (event.location != null)
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: MySizes.iconSm),
                          SizedBox(width: MySizes.spaceBtwItems / 2),
                          Text(
                            "${event.location!.locationName}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: MySizes.fontSizeSm),
                          ),
                        ],
                      )
                    else
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.white, size: MySizes.iconSm),
                          SizedBox(width: MySizes.spaceBtwItems / 2),
                          Text(
                            "Location: Not available",
                            style: TextStyle(
                                fontSize: MySizes.fontSizeSm,
                                color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
                SizedBox(height: MySizes.xs),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        color: Colors.white, size: MySizes.iconSm),
                    SizedBox(width: 8),
                    Text(
                      "${event.startTime}",
                      style: TextStyle(
                          fontSize: MySizes.fontSizeSm, color: Colors.white),
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

    Widget mapWidget;
    if (event.sportCategory.requiresRoute && event.route != null) {
      mapWidget = Container(
        margin: EdgeInsets.all(16),
        height: 200,
        child: FlutterMap(
          options: MapOptions(
            center: LatLng(event.route!.coordinatesFromPath[0][0],
                event.route!.coordinatesFromPath[0][1]),
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
            MarkerLayer(
              markers: [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageWidget,
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventInfo(
                eventDescription: event.description,
                maxParticipants: event.maxParticipants,
                currentNumParticipants: event.currentNumParticipants,
              ),
              SizedBox(height: MySizes.sm),
              Container(
                height: 300,
                child: ParticipantsList(
                  participants: participationController
                      .getParticipationsByEventId(event.id),
                ),
              ),
              mapWidget,
              // Insert map widget here
            ],
          ),
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
