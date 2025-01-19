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
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Récupérer l'ID de l'utilisateur depuis le stockage local
    userId = box.read('user_id') ?? 0;

    // Appeler la fonction pour charger les participations
    if (userId != 0) {
      _loadParticipations(); // Appel de la méthode privée
    } else {
      debugPrint("Aucun user_id trouvé dans le stockage local.");
    }
  }

  Future<void> _loadParticipations() async {
    try {
      // Appeler la méthode de récupération des participations
      await participationsAcceptedRefusedByUserId(userId);
    } catch (e) {
      debugPrint("Erreur lors du chargement des participations : $e");
    }
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
      // Correction de la déclaration de la variable `participationsRaw`
      List<Map<String, dynamic>> participationsRaw = await participationService
          .participationsAcceptedRefusedByUserId(userId);

      print("--------------------UserModel----------------------");
      print(participationsRaw);

      for (var participation in participationsRaw) {
        try {
          // Récupération des données utilisateur
          final UserModel user =
          await userService.fetchProfileData(participation['userId']);
          print(user.userName);

          // Récupération des données de l'événement
          final Event event =
          await eventService.getEventById(participation['eventId']);
          print("--------------------EventModel----------------------");
          print(event.name);

          // Ajout des données à la liste des participations
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
      debugPrint("Erreur lors de la récupération des participations : $e");
      return [];
    } finally {
      isLoading(false); // Assurez-vous de désactiver l'état de chargement
    }
  }

}
