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
  }) async {
    String url;

    if (category != null && dateFilter != null) {
      dateFilter = dateFilter.replaceAll(' ', '');
      url =
          '$gatewayEventUrl/api/events/filterByCategoryAndDate/$category/$dateFilter';
    } else if (dateFilter != null) {
      dateFilter = dateFilter.replaceAll(' ', '');
      url = '$gatewayEventUrl/api/events/filterByDate/$dateFilter';
    } else if (category != null) {
      url = '$gatewayEventUrl/api/categories/events/$category';
    } else {
      url = '$gatewayEventUrl/api/events/all-details';
    }

    try {
      final response = await http.get(Uri.parse(url));
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
        throw Exception('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      throw Exception('Failed to fetch events');
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
}
