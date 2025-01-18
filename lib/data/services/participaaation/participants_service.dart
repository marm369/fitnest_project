import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';
import '../../../utils/popups/loaders.dart';

class ParticipantsService {
  final String gatewayEventUrl = '$GatewayUrl/participation-service';

  Future<List<dynamic>> getParticipationsByEventId(int eventId) async {
    final String url = '$gatewayEventUrl/api/participations/event/$eventId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load participations. Status Code: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching participations: \$e');
    }
  }


}
