import 'package:fitnest/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/authentication/signup_service.dart';
import '../../../data/services/profile/update_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/loaders.dart';

class UpdateEmailController extends GetxController {
  static UpdateEmailController get instance => Get.find();
  final box = GetStorage();
  final formKeyEmail = GlobalKey<FormState>();
  final email = TextEditingController();
  int? userId;
  final UserService userService = UserService();
  final UpdateService updateService = UpdateService();
  final SignUpService signupService = SignUpService();
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
  Future<void> updateEmail() async {
    if (formKeyEmail.currentState?.validate() ?? false) {
      try {
        // Step 1: Retrieve the current user information
        final userInfo = await userService.fetchProfileDataAsJson(userId!);
        if (userInfo == null) {
          Loaders.errorSnackBar(
              title: 'Error', message: 'Unable to fetch user information.');
          return;
        }
        bool? check = await signupService.checkEmailAndUsername({
          'username': userInfo['account']['username'],
          'email': userInfo['account']['email']
        });

        if (check == true) {
          final result = await updateService.updateEmail({
            'accountId': userInfo['account']['id'],
            'email': email.text.trim()
          });
          if (result == true) {
            Loaders.successSnackBar(
                title: 'Success', message: 'Email updated successfully.');
          } else {
            Loaders.errorSnackBar(
                title: 'Error', message: 'Update failed, please try again.');
          }
        } else {
          Loaders.warningSnackBar(
              title: 'Warning',
              message: 'Email already exists, please try again.');
        }
      } catch (e) {
        Loaders.errorSnackBar(title: 'Error', message: 'An error occurred: $e');
      }
    } else {
      Loaders.errorSnackBar(
          title: 'Error', message: 'Please enter a valid Email.');
    }
  }
}
