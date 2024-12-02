import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SearchPlace {
  final String apiKey;

  SearchPlace({required this.apiKey});

  /// Retourne les coordonnées pour un emplacement donné
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    try {
      final url =
          'https://api.openrouteservice.org/geocode/search?text=$address&api_key=$apiKey';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['features'].isNotEmpty) {
          final latitude = data['features'][0]['geometry']['coordinates'][1];
          final longitude = data['features'][0]['geometry']['coordinates'][0];
          return LatLng(latitude, longitude);
        }
      }
    } catch (e) {
      print('Error fetching coordinates: $e');
    }
    return null;
  }
}
