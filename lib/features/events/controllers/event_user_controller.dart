import 'package:get/get.dart';
import '../../../data/services/event/event_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../models/event.dart';

class EventUserController extends GetxController {
  // Observable pour le nom de l'utilisateur
  var userName = ''.obs;
  final EventService eventService = EventService();
  var eventInfos = <Event>[].obs;

  final UserService _userService =
      UserService(); // Instanciation du service pour récupérer le nom.

  // Méthode pour récupérer le nom de l'utilisateur
  Future<void> fetchUserName(int userId) async {
    try {
      // Envoie du userId au service pour récupérer le nom de l'utilisateur
      var fetchedUserName = await _userService.fetchUserName(userId);
      userName.value = fetchedUserName;
    } catch (e) {
      // Gérer les erreurs si la récupération échoue
      print("Erreur lors de la récupération du nom d'utilisateur : $e");
      userName.value = 'Erreur de récupération';
    }
  }
  Future<List<Event>> getEventsByUser(int userId) async {
    try {
      // Await the fetch operation to get the data
      final eventData = await eventService.fetchUserEvents(userId);

      // Update the reactive list
      eventInfos.value = eventData;

      // Return the fetched data
      return eventData;
    } catch (e) {
      // Log the error for debugging purposes
      print('Error fetching user events: $e');

      // Return an empty list in case of an error
      return [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("EventUserController initialisé");
  }
}
