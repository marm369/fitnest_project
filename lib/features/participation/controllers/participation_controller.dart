import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/services/participation/participation_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../events/models/event.dart';
import '../../profile/models/user_model.dart';

class ParticipationController extends GetxController {
  final box = GetStorage();
  late int userId;
  var selectedMenu = 'Requests'.obs;
  final ParticipationService participationService = ParticipationService();
  final UserService userService = UserService();

  @override
  void onInit() {
    super.onInit();
    userId = box.read('user_id');
  }

  Future<bool> createParticipation(
      {required int eventId, required int organizerId}) async {
    try {
      print(
          'Création de la participation avec userId: $userId et eventId: $eventId');
      String result = await ParticipationService().createParticipation(
        userId: userId,
        eventId: eventId,
        organizerId: organizerId,
      );
      print('Réponse du service: $result');
      return true;
    } catch (e) {
      print('Erreur lors de la création de la participation: $e');
      return false;
    }
  }

  void changeMenu(String menu) {
    selectedMenu.value = menu;
  }

  Future<List<UserModel>> getParticipationsByEventId(int eventId) async {
    try {
      // Appel du service pour récupérer les participations brutes
      final List<Map<String, dynamic>> participationsRaw =
          await participationService.getParticipationsByEventId(eventId);

      // Initialisation de la liste finale
      List<UserModel> participants = [];

      for (var participation in participationsRaw) {
        try {
          final UserModel user =
              await userService.fetchProfileData(participation['userId']);
          participants.add(user);
        } catch (e) {
          print(
              "Erreur lors du traitement d'une participation individuelle : $e");
        }
      }
      return participants;
    } catch (e) {
      print("Erreur lors de la récupération des participations: $e");
      return [];
    }
  }

  Future<List<Event>> getParticipationsByUserId(int userId) async {
    try {
      return await participationService.getParticipationsByUserId(userId);
    } catch (e) {
      // Log the error for debugging purposes
      print('Error fetching user events: $e');

      // Return an empty list in case of an error
      return [];
    }
  }
}
