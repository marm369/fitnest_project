import 'package:fitnest/features/profile/controllers/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/profile/update_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/loaders.dart';

class UpdateDateOfBirthController extends GetxController {
  static UpdateDateOfBirthController get instance => Get.find();
  final box = GetStorage();
  final formKeyDateOfBirth = GlobalKey<FormState>();
  final dateOfBirth = TextEditingController();
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
  Future<void> updateDateOfBirth() async {
    if (formKeyDateOfBirth.currentState?.validate() ?? false) {
      try {
        // Step 1: Retrieve the current user information
        final userInfo = await userService.fetchProfileDataAsJson(userId!);
        if (userInfo == null) {
          Loaders.errorSnackBar(
              title: 'Error', message: 'Unable to fetch user information.');
          return;
        }
        userInfo['dateBirth'] = dateOfBirth.text.trim();
        final result = await updateService.updateInfos(userId!, userInfo);
        if (result == true) {
          Loaders.successSnackBar(
              title: 'Success', message: 'Date Of Birth updated successfully.');
        } else {
          Loaders.errorSnackBar(
              title: 'Error', message: 'Update failed, please try again.');
        }
      } catch (e) {
        Loaders.errorSnackBar(title: 'Error', message: 'An error occurred: $e');
      }
    } else {
      Loaders.errorSnackBar(
          title: 'Error', message: 'Please enter a valid date of birth.');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      dateOfBirth.text = pickedDate.toLocal().toString().split(' ')[0];
    }
  }
}
