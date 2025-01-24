import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';

class ParticipationService {
  final String participationUrl =
      '$GatewayUrl/participation-service/api/participations';
  final String gatewayEventUrl = '$GatewayUrl/event-service';

  /// Méthode pour créer une participation
  Future<String> createParticipation({
    required int userId,
    required int eventId
  }) async {
    try {
      // Construire l'URL avec les paramètres
      final url = Uri.parse(
        '$participationUrl/createParticipation?userId=$userId&eventId=$eventId',
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
        // Décodage de la réponse JSON
        final List<dynamic> rawParticipations =
        jsonDecode(utf8.decode(response.bodyBytes));

        // Conversion explicite en List<Map<String, dynamic>>
        final List<Map<String, dynamic>> participations = rawParticipations
            .map((item) => Map<String, dynamic>.from(item))
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

  Future<List<Map<String, dynamic>>> participationsParOrganizerId(
      int organizerId) async {
    try {
      // Endpoint pour récupérer les événements de l'organizer
      final eventsUrl = Uri.parse('$gatewayEventUrl/api/events/organizers/$organizerId/events');

      // Requête pour les événements
      final eventsResponse = await http.get(
        eventsUrl,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (eventsResponse.statusCode == 200) {
        final List<dynamic> events = jsonDecode(utf8.decode(eventsResponse.bodyBytes));
        final List<Map<String, dynamic>> allParticipations = [];

        // Boucle pour chaque événement
        for (var event in events) {
          final int eventId = event['id'];

          // Endpoint pour récupérer les participations de l'événement
          final participationUrl1 = Uri.parse('$participationUrl/event/$eventId');
          final participationResponse = await http.get(
            participationUrl1,
            headers: {
              'Content-Type': 'application/json',
            },
          );

          if (participationResponse.statusCode == 200) {
            final List<dynamic> participations = jsonDecode(utf8.decode(participationResponse.bodyBytes));

            // Filtrer les participations avec le statut ACTIVE
            final activeParticipations = participations
                .where((participation) => participation['statusParticipation'] == 'ACTIVE')
                .cast<Map<String, dynamic>>()
                .toList();

            // Ajouter les participations actives à la liste consolidée
            allParticipations.addAll(activeParticipations);
          } else {
            throw Exception(
                "Failed to fetch participations for event $eventId: ${participationResponse.statusCode} - ${participationResponse.reasonPhrase}");
          }
        }

        return allParticipations;
      } else {
        throw Exception(
            "Failed to fetch events for organizer $organizerId: ${eventsResponse.statusCode} - ${eventsResponse.reasonPhrase}");
      }
    } catch (error) {
      throw Exception("An error occurred while fetching participations: $error");
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
        participation['statusParticipation'] == 'ACCEPTED')
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
              .map((event) => Event.fromJson1(event as Map<String, dynamic>))
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
