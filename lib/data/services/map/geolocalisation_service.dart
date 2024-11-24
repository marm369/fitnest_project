import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../../../utils/popups/loaders.dart';

class GeolocalisationService {
  final String gatewayGeoUrl = '$GatewayUrl/geolocalisation-service';
  Future<int?> createLocation(
      String locationName, double latitude, double longitude) async {
    try {
      final locationBody = {
        "locationName": locationName,
        "latitude": latitude,
        "longitude": longitude,
      };

      final response = await http.post(
        Uri.parse('$gatewayGeoUrl/api/locations/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(locationBody),
      );

      if (response.statusCode == 200) {
        final locationData = jsonDecode(response.body);
        return locationData['id'];
      } else {
        Loaders.errorSnackBar(
            title: "Error",
            message: "Error during the creation of the location");
      }
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Error", message: "Server connection error : $e");
    }
    return null;
  }

  /// Create a route and return its ID.
  Future<int?> createRoute(RxList<List<double>> routeCoordinates) async {
    try {
      final routeBody = {
        "type": "LineString",
        "coordinates": routeCoordinates,
      };

      final response = await http.post(
        Uri.parse('$gatewayGeoUrl/api/routes/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(routeBody),
      );

      if (response.statusCode == 200) {
        final routeData = jsonDecode(response.body);
        Loaders.successSnackBar(
            title: "Success", message: "Route created successfully!");
        print(routeData['id']);
        return routeData['id'];
      } else {
        Loaders.errorSnackBar(
            title: "Error", message: "Error during the creation of the route");
      }
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Error", message: "Connection or data processing error: $e");
    }
    return null;
  }
}
