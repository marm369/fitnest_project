import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class CurrentPosition {
  // Making this method public so it can be used outside this class
  Future<LatLng> determinePosition() async {
    try {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        // Return the initial position to be used in the builder
        return LatLng(position.latitude, position.longitude);
      } else {
        print('Location permission denied.');
        throw Exception('Location permission denied');
      }
    } catch (e) {
      print('Error getting current location: $e');
      throw Exception('Error getting current location');
    }
  }
}
