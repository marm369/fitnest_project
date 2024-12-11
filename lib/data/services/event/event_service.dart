import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';
import '../../../utils/popups/loaders.dart';

class EventService {
  final String gatewayEventUrl = '$GatewayUrl/event-service';

  Future<List<Event>> fetchEvents({
    String? category,
    String? dateFilter,
    String? partDay,
    String? distance,
    double? latitude,
    double? longitude,
  }) async {
    String url;
    print("category: $category");
    print("dateFilter: $dateFilter");
    print("partDay $partDay");
    print("distance: $distance");
    print("latitude: $latitude");
    print("longitude: $longitude");
    if (category != null && dateFilter != '' && partDay != '') {
      dateFilter = dateFilter?.replaceAll(' ', '') ?? '';
      url = '$gatewayEventUrl/api/events/filter/$category/$dateFilter/$partDay';
    } else if (category != null && dateFilter != '') {
      dateFilter = dateFilter?.replaceAll(' ', '') ?? '';
      url =
          '$gatewayEventUrl/api/events/filterByCategoryAndDate/$category/$dateFilter';
    } else if (dateFilter != '') {
      dateFilter = dateFilter?.replaceAll(' ', '') ?? '';
      url = '$gatewayEventUrl/api/events/filterByDate/$dateFilter';
    } else if (category != null) {
      url = '$gatewayEventUrl/api/categories/events/$category';
    } else if (partDay != '') {
      url = '$gatewayEventUrl/api/events/byPartOfDay/$partDay';
    } else if (distance != '' && latitude != 0.0 && longitude != 0.0)
      url =
          '$gatewayEventUrl/api/events/nearby?latitude=$latitude&longitude=$longitude&radius=$distance';
    else if (partDay != '' && dateFilter != '' && category != null)
      url = '$gatewayEventUrl/filter/{categoryName}/{filter}/{partDay}';
    else
      url = '$gatewayEventUrl/api/events/all-details';
    try {
      final response = await http.get(Uri.parse(url));

      print("URL appelée: $url");
      print("Code de statut: ${response.statusCode}");
      print("Réponse brute: ${response.body}");

      if (response.statusCode == 200) {
        final eventsJson = json.decode(utf8.decode(response.bodyBytes));

        // Si la réponse est null ou vide, afficher un message et retourner une liste vide
        if (eventsJson == null || eventsJson.isEmpty) {
          print("Réponse vide ou null reçue");
          return [];
        }

        if (eventsJson is List) {
          return eventsJson
              .where((event) => event != null && event is Map<String, dynamic>)
              .map((event) {
            return Event.fromJson(event as Map<String, dynamic>);
          }).toList();
        } else {
          throw Exception('Format JSON inattendu : attendu une liste');
        }
      } else {
        print(
            'Échec du chargement des événements. Code de statut: ${response.statusCode}');
        throw Exception('Échec du chargement des événements');
      }
    } catch (e) {
      print('Erreur lors de la récupération des événements: $e');
      throw Exception('Échec de la récupération des événements');
    }
  }

  Future<List<Event>> fetchEventsWithDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$gatewayEventUrl/api/events/all-details'));

      if (response.statusCode == 200) {
        final eventsJson = json.decode(utf8.decode(response.bodyBytes));
        if (eventsJson is List) {
          return eventsJson
              .where((event) => event != null && event is Map<String, dynamic>)
              .map((event) {
            return Event.fromJson(event as Map<String, dynamic>);
          }).toList();
        } else {
          throw Exception('Unexpected JSON format: expected a List');
        }
      } else {
        print('Failed to load events. Status code: ${response.statusCode}');
        throw Exception('Failed to load events');
      }
    } catch (e) {
      print('Error in fetchEventsWithDetails: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<void> createEvent(Map<String, dynamic> requestBody) async {
    try {
      final response = await http.post(
        Uri.parse('$gatewayEventUrl/api/events/createEvent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        Loaders.successSnackBar(
            title: 'Success', message: "Event created successfully!");
      } else {
        Loaders.errorSnackBar(
            title: 'Error', message: "Error while creating the event.");
      }
    } catch (e) {
      Loaders.errorSnackBar(
          title: 'Error', message: "Server connection error: $e");
    }
  }

  Future<List<Event>> fetchUserEvents(int userId) async {
    final String apiUrl = "$gatewayEventUrl/api/events/user/$userId/events";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((event) => Event.fromJson(event)).toList();
      } else {
        throw Exception(
            "Failed to load events with status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching events: $e");
    }
  }

  Future<List<Event>> fetchNearbyEvents({
    required double latitude,
    required double longitude,
    required String distance,
  }) async {
    try {
      // Construire l'URL
      final uri = Uri.parse(
          '$gatewayEventUrl/event-service/api/events/nearby?latitude=$latitude&longitude=$longitude&radius=$distance');
      final response = await http.get(uri);
      print("url appelée:${uri}");
      // Vérifier le statut de la réponse
      if (response.statusCode == 200) {
        // Décoder les données JSON
        final eventsJson = json.decode(utf8.decode(response.bodyBytes));

        // Retourner la liste des événements
        if (eventsJson is List) {
          return eventsJson
              .where((event) => event != null && event is Map<String, dynamic>)
              .map((event) => Event.fromJson(event as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected JSON format: expected a List');
        }
      } else {
        print(
            'Failed to fetch nearby events. Status code: ${response.statusCode}');
        throw Exception('Failed to fetch nearby events');
      }
    } catch (e) {
      print('Error in fetchNearbyEvents: $e');
      throw Exception('Failed to fetch nearby events: $e');
    }
  }

  /// Méthode de parsing des événements JSON
  List<Event> parseEvents(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Event>((json) => Event.fromJson(json)).toList();
  }

  Future<Event> fetchEvent(int eventId) async {
    final String apiUrl = "$GatewayUrl/event-service/api/events/$eventId/details";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return Event.fromJson(json.decode(response.body)); // Correct parentheses and method call
      } else {
        throw Exception(
            "Failed to load event with status code ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching event: $e");
    }
  }
}
