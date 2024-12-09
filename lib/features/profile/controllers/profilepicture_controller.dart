import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'dart:convert';
import '../../../data/services/profile/update_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/loaders.dart';

class UpdateProfilePictureController extends GetxController {
  final box = GetStorage();
  final updateService = UpdateService();
  final userService = UserService();

  var imagePreview = Rx<File?>(null);
  late int userId;

  @override
  void onInit() {
    super.onInit();
    userId = box.read<int>('user_id') ?? -1;
    if (userId == -1) {
      Loaders.errorSnackBar(
          title: 'Error', message: 'User ID is missing. Please log in again.');
    }
  }

  void setImageFile(File file) {
    imagePreview.value = file;
  }

  Future<bool> updateProfilePicture() async {
    if (imagePreview.value == null) {
      Loaders.errorSnackBar(
          title: 'Error', message: 'Please select an image before saving.');
      return false;
    }
    try {
      final file = imagePreview.value!;
      final imageBytes = await file.readAsBytes();
      final encodedImage = base64Encode(imageBytes);
      // Récupérer les données de l'utilisateur
      final userInfo = await userService.fetchProfileDataAsJson(userId);
      if (userInfo == null) {
        Loaders.errorSnackBar(
            title: 'Error', message: 'Unable to fetch user information.');
        return false;
      }
      // Mettre à jour la photo de profil
      userInfo['profilePicture'] = encodedImage;
      final result = await updateService.updateInfos(userId, userInfo);
      print(result);
      if (result!) {
        Loaders.successSnackBar(
            title: 'Success', message: 'Profile picture updated successfully.');
        return true;
      } else {
        Loaders.errorSnackBar(
            title: 'Error', message: 'Update failed, please try again.');
        return false;
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Error', message: 'An error occurred: $e');
      return false;
    }
  }
}
