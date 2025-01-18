import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/tracking_model.dart';

class TrackingService {
  Future<Tracking> fetchEventLocation(int eventId) async {
    final url = Uri.parse('https://localhost:8085/tracking/$eventId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Tracking.fromJson(data);
    } else {
      throw Exception('Failed to fetch location: ${response.statusCode}');
    }
  }
}
