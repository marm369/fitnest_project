import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/event/event_service.dart';
import '../../../data/services/participation/participation_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../events/models/event.dart';
import '../../profile/models/user_model.dart';
import '../models/participation_model.dart';

class RequestsController extends GetxController {
  final ParticipationService participationService = ParticipationService();
  final UserService userService = UserService();
  final EventService eventService = EventService();
  final box = GetStorage();
  late int organizerId;

  var participations = <ParticipationModel>[].obs;
  var isLoading = false.obs; // Ajoutez cette ligne

  @override
  void onInit() {
    super.onInit();
    organizerId = box.read('user_id') ?? 0;

    fetchAndSetParticipations();
  }

  Future<void> fetchAndSetParticipations() async {
    try {
      isLoading(true); // Début du chargement
      final fetchedParticipations = await fetchParticipations(organizerId);
      participations.value = fetchedParticipations; // Remplace toute la liste
    } catch (e) {
      debugPrint("Erreur lors du chargement des participations: $e");
    } finally {
      isLoading(false); // Fin du chargement
    }
  }

  Future<List<ParticipationModel>> fetchParticipations(int organizerId) async {
    try {
      final List<Map<String, dynamic>> participationsRaw =
      await participationService.participationsParOrganizerId(organizerId);
      List<ParticipationModel> participations = [];

      for (var participation in participationsRaw) {
        try {
          final UserModel user =
          await userService.fetchProfileData(participation['userId']);
          final Event event =
          await eventService.getEventById(participation['eventId']);

          // Créer un modèle de participation complet
          participations.add(
            ParticipationModel.fromParticipation(
              participation,
              event,
              user,
            ),
          );
        } catch (e) {
          debugPrint(
              "Erreur lors du traitement d'une participation individuelle : $e");
        }
      }

      return participations;
    } catch (e) {
      debugPrint("Erreur lors de la récupération des participations: $e");
      return [];
    }
  }

  // Cancel participation
  Future<void> cancelParticipation(int userId, int eventId) async {
    try {
      await participationService.cancelParticipation(userId, eventId);
    } catch (e) {
      throw Exception('Error occurred while canceling participation: $e');
    }
  }

  // Accept participation
  Future<void> acceptParticipation(int userId, int eventId) async {
    try {
      await participationService.acceptParticipation(userId, eventId);
    } catch (e) {
      throw Exception('Error occurred while accepting participation: $e');
    }
  }
}