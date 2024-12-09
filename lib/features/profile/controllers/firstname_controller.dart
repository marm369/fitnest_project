import 'package:fitnest/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/profile/update_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class UpdateFirstNameController extends GetxController {
  static UpdateFirstNameController get instance => Get.find();
  final box = GetStorage();
  final formKeyFirstName = GlobalKey<FormState>();
  final firstName = TextEditingController();
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

  // Function to update the user's first name
  Future<void> updateFirstName() async {
    if (formKeyFirstName.currentState?.validate() ?? false) {
      try {
        // Step 1: Retrieve the current user information
        final userInfo = await userService.fetchProfileDataAsJson(userId!);
        if (userInfo == null) {
          Loaders.errorSnackBar(
              title: 'Error', message: 'Unable to fetch user information.');
          return;
        }
        userInfo['firstName'] = firstName.text.trim();
        final result = await updateService.updateInfos(userId!, userInfo);
        if (result == true) {
          Loaders.successSnackBar(
              title: 'Success', message: 'First name updated successfully.');
        } else {
          Loaders.errorSnackBar(
              title: 'Error', message: 'Update failed, please try again.');
        }
      } catch (e) {
        Loaders.errorSnackBar(title: 'Error', message: 'An error occurred: $e');
      }
    } else {
      Loaders.errorSnackBar(
          title: 'Error', message: 'Please enter a valid first name.');
    }
  }
}
