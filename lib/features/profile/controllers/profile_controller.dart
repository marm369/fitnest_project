import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/services/profile/change_username_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';
import '../../events/models/event.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  // Observables
  var userName = ''.obs;
  var userProfile = Rxn<UserModel>();
  var userEvents = <Event>[].obs;

  // Dependencies
  final box = GetStorage();
  final usernameController = TextEditingController();
  final UserService _userService = UserService();

  // Initialization
  @override
  void onInit() {
    super.onInit();
    final int? userId = box.read<int>('user_id');
    if (userId != null) {
      _initializeProfile(userId);
    } else {
      print("Error: User ID not found in storage.");
    }
  }

  // Private method to initialize profile data
  Future<void> _initializeProfile(int userId) async {
    String token = box.read<String>('token') ?? '';
    if (token.isEmpty) {
      print("Error: Token not found in storage.");
      return;
    }

    await fetchProfileData(userId);
    //await fetchUserEvents(userId);
    await fetchUserName(userId);
  }

  // Fetch user's name
  Future<void> fetchUserName(int userId) async {
    try {
      final fetchedUserName = await _userService.fetchUserName(userId);
      userName.value = fetchedUserName;
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  // Fetch profile data
  Future<void> fetchProfileData(int userId) async {
    try {
      final profileData = await _userService.fetchProfileData(userId);
      userProfile.value = profileData; // Store fetched data in observable
    } catch (e) {
      print("Error fetching profile data: $e");
    }
  }

  /*
  // Update username (if required in future functionality)
  Future<void> updateUserName(String newUserName) async {
    try {
      final success = await ChangeUsernameService.changeUsername(newUserName);
      if (success) {
        userName.value = newUserName; // Update observable
        print("Username updated successfully.");
      } else {
        print("Failed to update username.");
      }
    } catch (e) {
      print("Error updating username: $e");
    }
  }*/
}
