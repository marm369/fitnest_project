import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../configuration/config.dart';

class FeedbackService {
  final String baseUrl =  '$GatewayUrl/feedback-service/api/feedbacks';

  // Fonction pour récupérer les événements d'un utilisateur donné
  Future<List<Map<String, dynamic>>> fetchEventsByUserId(int userId) async {
    print('[FeedbackService] fetchEventsByUserId called for userId: $userId');
    final url = Uri.parse(baseUrl+'/event/User/$userId');
    print('[FeedbackService] Sending GET request to $url');

    try {
      final response = await http.get(url);
      print('[FeedbackService] Response status code: ${response.statusCode}');
      print('[FeedbackService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Si la requête réussit, on retourne la liste des événements
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        print('[FeedbackService] Parsed events: $data');
        return data.map((event) => event as Map<String, dynamic>).toList();
      } else {
        print('[FeedbackService] Failed to load events. Status code: ${response.statusCode}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('[FeedbackService] Error in fetchEventsByUserId: $e');
      throw e;
    }
  }

  // Fonction pour soumettre un feedback
  Future<void> submitFeedback(Map<String, dynamic> feedbackData) async {
    final url = Uri.parse(baseUrl);
    print('[FeedbackService] submitFeedback called with data: $feedbackData');
    print('[FeedbackService] Sending POST request to $url');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(feedbackData),
      );

      print('[FeedbackService] Response status code: ${response.statusCode}');
      print('[FeedbackService] Response body: ${response.body}');

      if (response.statusCode != 200) {
        print('[FeedbackService] Failed to submit feedback. Status code: ${response.statusCode}');
        throw Exception('Failed to submit feedback');
      } else {
        print('[FeedbackService] Feedback submitted successfully.');
      }
    } catch (e) {
      print('[FeedbackService] Error in submitFeedback: $e');
      throw e;
    }
  }
}
