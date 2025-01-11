import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:get/get.dart';

import '../../profile/controllers/profile_controller.dart';

class TrackingScreen extends StatefulWidget {
  final int organizerId;

  TrackingScreen({required this.organizerId});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  LatLng? initialPosition;
  LatLng? currentPosition;
  final List<LatLng> pathPositions = []; // Liste pour les positions suivies
  final MapController _mapController = MapController();
  final ProfileController _profileController = Get.put(ProfileController());
  Timer? _timer;
  bool showProfileCard = false;

  @override
  void initState() {
    super.initState();
    _profileController.fetchProfileData(widget.organizerId);
    fetchTrackingData();
    _timer = Timer.periodic(Duration(seconds: 2), (_) => fetchTrackingData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchTrackingData() async {
    final url = Uri.parse('http://localhost:8085/api/Tracking/4');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['latitude'] != null && data['longitude'] != null) {
          setState(() {
            final newPosition = LatLng(
              data['latitude'],
              data['longitude'],
            );
            if (initialPosition == null) {
              initialPosition = newPosition;
            }
            currentPosition = newPosition;

            pathPositions.add(newPosition);

            _mapController.move(currentPosition!, _mapController.zoom);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Données incorrectes : latitude/longitude manquantes.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de récupération (${response.statusCode})')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau : $e')),
      );
    }
  }
  ImageProvider getUserProfileImage(String? base64Image) {
    if (base64Image != null && base64Image.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(base64Image));
      } catch (e) {
        print("Erreur lors du décodage de l'image : $e");
      }
    }
    return const AssetImage('assets/images/default_user.png');
  }

  Widget buildProfileCard() {
    final userProfile = _profileController.userProfile.value; // Données récupérées
    if (userProfile == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (userProfile.profilePicture != null)
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: getUserProfileImage(userProfile.profilePicture),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300], // Placeholder color
                ),
                child: Icon(Icons.person, size: 24.0, color: Colors.grey[700]),
              ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${userProfile.firstName} ${userProfile.lastName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text('Téléphone: ${userProfile.phoneNumber}'),
                Text('Email: ${userProfile.email}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Real-time Tracking"),
      ),
      body: Stack(
        children: [
          // Contenu principal : Carte et suivi
          Column(
            children: [
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: currentPosition ?? LatLng(33.5792, -7.6133),
                    zoom: 15,
                  ),
                  nonRotatedChildren: [
                    TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    if (pathPositions.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: pathPositions,
                            color: Colors.blue,
                            strokeWidth: 4.0,
                            isDotted: true,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        if (initialPosition != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: initialPosition!,
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 40.0,
                            ),
                          ),
                        if (currentPosition != null)
                          Marker(
                            width: 80.0,
                            height: 80.0,
                            point: currentPosition!,
                            builder: (ctx) => const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 40.0,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Carte d'information à gauche
          Positioned(
            top: 16.0,
            left: 16.0,
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Organizer Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    if (currentPosition != null) ...[
                      Text('Latitude: ${currentPosition!.latitude.toStringAsFixed(5)}'),
                      Text('Longitude: ${currentPosition!.longitude.toStringAsFixed(5)}'),
                    ] else
                      const Text('Fetching location...'),
                  ],
                ),
              ),
            ),
          ),
          // Carte de profil en bas
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: buildProfileCard(),
          ),
        ],
      ),
    );
  }

}
