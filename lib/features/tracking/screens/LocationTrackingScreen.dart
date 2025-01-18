import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class OrganizerPositionSender extends StatefulWidget {
  @override
  _OrganizerPositionSenderState createState() =>
      _OrganizerPositionSenderState();
}

class _OrganizerPositionSenderState extends State<OrganizerPositionSender> {
  late WebSocketChannel _channel;
  LatLng _currentPosition = LatLng(0.0, 0.0); // Position actuelle de l'organisateur
  bool _isSendingPosition = false;
  Timer? _positionUpdateTimer; // Timer pour mettre à jour la position régulièrement

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.26:8085/ws/positions?organizerId=4'));
    _startPositionTracking(); // Commencer à suivre la position
  }

  // Fonction pour obtenir la position de l'organisateur et l'envoyer
  Future<void> _startPositionTracking() async {
    _positionUpdateTimer = Timer.periodic(Duration(seconds: 10), (timer) async {
      Position position = await _getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });

      // Envoi de la position via WebSocket
      _sendPositionToServer();
    });
  }

  // Fonction pour obtenir la position actuelle
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled || permission == LocationPermission.denied) {
      // Demander l'accès à la localisation si nécessaire
      await Geolocator.requestPermission();
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Fonction pour envoyer la position de l'organisateur via WebSocket
  void _sendPositionToServer() {
    final positionData = {
      'organizerId': '4',
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
    };

    _channel.sink.add(jsonEncode(positionData)); // Envoi de la position
    print("Position envoyée: $_currentPosition");
  }

  @override
  void dispose() {
    _positionUpdateTimer?.cancel(); // Annuler le timer lorsque l'écran est détruit
    _channel.sink.close(); // Fermer la connexion WebSocket
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Position de l'Organisateur")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Position actuelle de l'organisateur:"),
            Text(
              'Latitude: ${_currentPosition.latitude}, Longitude: ${_currentPosition.longitude}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendPositionToServer,
              child: Text("Envoyer la position au serveur"),
            ),
          ],
        ),
      ),
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
