import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';

class ParticipationService {
  final String participationUrl =
      '$GatewayUrl/participation-service/api/participations';

  /// Méthode pour créer une participation
  Future<String> createParticipation({
    required int userId,
    required int eventId,
    required int organizerId,
  }) async {
    try {
      // Construire l'URL avec les paramètres
      final url = Uri.parse(
        '$participationUrl/createParticipation?userId=$userId&eventId=$eventId&organizerId=$organizerId',
      );

      // Construire la requête POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      // Vérifier les statuts HTTP
      if (response.statusCode == 200) {
        return "Participation created successfully";
      } else if (response.statusCode == 400) {
        throw Exception("User already participates in this event.");
      } else if (response.statusCode == 409) {
        throw Exception("Event is full.");
      } else {
        throw Exception(
            "Failed to create participation: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      throw Exception("An error occurred while creating participation: $error");
    }
  }

  Future<List<Map<String, dynamic>>> participationsParOrganizerId(
      int organizerId) async {
    try {
      // Construire l'URL de la requête GET
      final url =
          Uri.parse('$participationUrl/organizer/$organizerId/participations');

      // Construire la requête GET
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Vérifier les statuts HTTP
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));

        // Filtrer les participations ayant le statut ACTIVE
        final List<Map<String, dynamic>> participations = decodedResponse
            .where((participation) =>
                participation['status_participation'] == 'ACTIVE')
            .cast<Map<String, dynamic>>()
            .toList();

        return participations;
      } else {
        throw Exception(
            "Failed to fetch participations: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      throw Exception(
          "An error occurred while fetching participations: $error");
    }
  }

  Future<List<Map<String, dynamic>>> participationsAcceptedRefusedByUserId(
      int userId) async {
    try {
      final url = Uri.parse('$participationUrl/user/$userId/accepted_refused');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> participations =
            jsonDecode(utf8.decode(response.bodyBytes));

        return participations;
      } else {
        throw Exception(
            "Failed to fetch participations: ${response.statusCode} - ${response.reasonPhrase}");
      }
    } catch (error) {
      throw Exception(
          "An error occurred while fetching participations: $error");
    }
  }

  Future<void> cancelParticipation(int userId, int eventId) async {
    try {
      final url =
          Uri.parse('$participationUrl/delete?userId=$userId&eventId=$eventId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 204) {
        print('Participation canceled successfully.');
      } else {
        throw Exception(
            'Failed to cancel participation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while canceling participation: $e');
    }
  }

  // Accept participation
  Future<void> acceptParticipation(int userId, int eventId) async {
    try {
      final url =
          Uri.parse('$participationUrl/accept?userId=$userId&eventId=$eventId');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 204) {
        print('Participation accepted successfully.');
      } else {
        throw Exception(
            'Failed to accept participation: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while accepting participation: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getParticipationsByEventId(
      int eventId) async {
    final url = Uri.parse('$participationUrl/event/$eventId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        final List<Map<String, dynamic>> participations = decodedResponse
            .where((participation) =>
                participation['status_participation'] == 'ACCEPTED')
            .cast<Map<String, dynamic>>()
            .toList();
        return participations;
      } else {
        throw Exception(
            'Erreur lors de la récupération des participations : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }

  Future<List<Event>> getParticipationsByUserId(int userId) async {
    final url = Uri.parse('$participationUrl/user/$userId/participations');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Décoder les données JSON
        final eventsJson = json.decode(utf8.decode(response.bodyBytes));

        if (eventsJson is List) {
          return eventsJson
              .where((event) => event != null && event is Map<String, dynamic>)
              .map((event) => Event.fromJson(event as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception('Unexpected JSON format: expected a List');
        }
      } else {
        throw Exception(
            'Erreur lors de la récupération des participations : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }
}
