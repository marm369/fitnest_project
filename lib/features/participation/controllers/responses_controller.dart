import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/services/participation/participation_service.dart';
import '../../../data/services/event/event_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../events/models/event.dart';
import '../../profile/models/user_model.dart';
import '../models/participation_model.dart';

class ResponsesController extends GetxController {
  final box = GetStorage();
  late int userId;
  final ParticipationService participationService = ParticipationService();
  final EventService eventService = EventService();
  final UserService userService = UserService();

  var participations = <ParticipationModel>[].obs;
  var isLoading = false.obs; // Ajoutez cette ligne
  @override
  void onInit() {
    super.onInit();
    userId = box.read('user_id');
  }

  Future<List<Event>> getParticipationsByUserId(int userId) async {
    try {
      final eventData =
          await participationService.getParticipationsByUserId(userId);

      return eventData;
    } catch (e) {
      print('Error fetching user events: $e');
      return [];
    }
  }

  Future<List<ParticipationModel>> participationsAcceptedRefusedByUserId(
      int userId) async {
    try {
      isLoading(true);
      final participationsRaw = await participationService
          .participationsAcceptedRefusedByUserId(userId);
      for (var participation in participationsRaw) {
        try {
          final UserModel user =
              await userService.fetchProfileData(participation['userId']);
          final Event event =
              await eventService.getEventById(participation['eventId']);
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
    } finally {
      isLoading(false); // Fin du chargement
    }
  }
}
