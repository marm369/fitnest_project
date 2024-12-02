import 'package:get/get.dart';
import '../../../data/services/profile/user_service.dart';

class EventUserController extends GetxController {
  // Observable pour le nom de l'utilisateur
  var userName = ''.obs;

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

  @override
  void onInit() {
    super.onInit();
    print("EventUserController initialisé");
  }
}
