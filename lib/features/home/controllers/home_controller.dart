import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/user_service.dart';

class HomeController extends GetxController {
  // Observable pour le nom de l'utilisateur
  var userName = ''.obs;
  final box = GetStorage();
  final UserService _userService =
      UserService(); // Correction : Instanciation du service

  @override
  void onInit() {
    super.onInit();
    // Lire l'ID utilisateur depuis le stockage
    int? userId = box.read('user_id');

    if (userId != null) {
      fetchUserName(userId);
    } else {
      print("Aucun ID utilisateur trouvé dans le stockage.");
    }
  }

  // Méthode pour récupérer le nom de l'utilisateur
  Future<void> fetchUserName(int userId) async {
    userName.value = await _userService.fetchUserName(userId);
    print(userName.value);
  }
}
