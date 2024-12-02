import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';

class CreationItineraire extends StatefulWidget {
  @override
  _CreationItineraireState createState() => _CreationItineraireState();
}

class _CreationItineraireState extends State<CreationItineraire> {
  List<LatLng> routePoints = [];

  // Ajouter un point sélectionné à la liste des points
  void _addPoint(LatLng point) {
    setState(() {
      routePoints.add(point);
    });
  }

  // Calculer l'itinéraire en passant par tous les points ajoutés
  Future<void> _calculateRoute() async {
    if (routePoints.length < 2)
      return; // Besoin d'au moins 2 points pour un itinéraire

    // Construire la chaîne des points pour la requête
    String coordinates = routePoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');

    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$ORSAPIKey&coordinates=$coordinates';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final coordinatesData =
          data['features'][0]['geometry']['coordinates'] as List;

      setState(() {
        routePoints =
            coordinatesData.map((coord) => LatLng(coord[0], coord[1])).toList();
      });

      // Affiche les coordonnées de l'itinéraire dans la console
      print("Itinéraire calculé : $routePoints");
    } else {
      print('Erreur lors du calcul de l\'itinéraire');
    }
  }

  Future<void> _saveItineraire() async {
    if (routePoints.isNotEmpty) {
      final coordinates = convertLatLngToMap(routePoints);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Itinéraire créé avec succès!")),
      );
      Navigator.pop(context, coordinates); // Retourne les coordonnées
    }
  }

  List<List<double>> convertLatLngToMap(List<LatLng> latLngList) {
    return latLngList.map((latLng) {
      return [latLng.latitude, latLng.longitude];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carte d\'Itinéraire'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveItineraire,
          ),
          IconButton(
            icon: Icon(Icons.directions),
            onPressed:
                _calculateRoute, // Calculer l'itinéraire entre les points
          ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(33.69898407070958, -7.401901307269943),
          zoom: 13.0,
          onTap: (tapPosition, point) => _addPoint(point),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: routePoints
                .map((point) => Marker(
                      point: point,
                      builder: (ctx) =>
                          Icon(Icons.location_on, color: Colors.blue),
                    ))
                .toList(),
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [
                Polyline(
                  points: routePoints,
                  strokeWidth: 4.0,
                  color: Colors.blue,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
