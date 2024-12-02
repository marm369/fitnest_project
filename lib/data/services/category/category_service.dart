import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configuration/config.dart';
import '../../../features/events/models/category.dart';
import '../../../features/home/models/event_scroll.dart';

class CategoryService {
  final String gatewayBaseUrl = '$GatewayUrl/event-service';

  Future<List<Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('$gatewayBaseUrl/api/categories/getCategories'));
    if (response.statusCode == 200) {
      // Décoder la réponse en UTF-8
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(utf8Body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<RxList<EventScroll>> fetchEventByCategories(String category) async {
    try {
      print("Fetching events for category: $category");

      // Requête pour récupérer les événements
      final response = await http.get(
        Uri.parse('$gatewayBaseUrl/api/categories/events/$category'),
      );

      if (response.statusCode == 200) {
        // Décoder la réponse
        String utf8Body = utf8.decode(response.bodyBytes);
        List<dynamic> eventsData = json.decode(utf8Body);

        // Liste des événements enrichis
        RxList<EventScroll> eventList = RxList<EventScroll>();

        for (var eventJson in eventsData) {
          print("Event data retrieved: ${eventJson['name']}");

          // Créer un objet EventScroll
          EventScroll event = EventScroll.fromJson(eventJson);

          // Récupérer l'ID de l'organisateur
          String organiserId = eventJson['organizerId'];
          print("Organizer ID: $organiserId");

          // Requête pour récupérer les informations de l'organisateur
          final userResponse = await http.get(
            Uri.parse('$gatewayBaseUrl/auth-service/getUserById/$organiserId'),
          );

          if (userResponse.statusCode == 200) {
            // Décoder les données utilisateur
            String utf8UserBody = utf8.decode(userResponse.bodyBytes);
            Map<String, dynamic> userData = json.decode(utf8UserBody);

            // Ajouter les informations de l'organisateur à l'événement
            event.organiserName =
                "${userData['firstName']} ${userData['lastName']}";
            event.organiserImage = userData['profilePicture'] ?? '';

            print("Organizer Name: ${event.organiserName}");
          } else {
            print("Failed to load organizer information for ID: $organiserId");
          }

          // Ajouter l'événement à la liste
          eventList.add(event);
        }

        return eventList;
      } else {
        throw Exception(
            'Failed to load events. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching events: $e");
      throw Exception('Error fetching events: $e');
    }
  }
}
