import 'package:fitnest/features/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/profile/update_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/loaders.dart';

class BioController extends GetxController {
  var isExpanded = false.obs;
  RxString bioText = ''.obs;
  final box = GetStorage();
  int? userId;
  final UserService userService = UserService();
  final UpdateService updateService = UpdateService();
  final ProfileController profileController = ProfileController();

  @override
  void onInit() {
    super.onInit();
    userId = box.read<int>('user_id');
    if (userId == null) {
      Loaders.errorSnackBar(
          title: 'Error', message: 'User ID is missing. Please log in again.');
    }
  }

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  Future<void> updateBio(String newBio) async {
    bioText.value = newBio;
    try {
      final userInfo = await userService.fetchProfileDataAsJson(userId!);
      if (userInfo == null) {
        Loaders.errorSnackBar(
            title: 'Error', message: 'Unable to fetch user information.');
        return;
      }
      userInfo['description'] = bioText.value.trim();
      final result = await updateService.updateInfos(userId!, userInfo);
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'An error occurred: $e');
    }
  }
}
