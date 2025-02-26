import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/profile/user_service.dart';
import '../../events/models/event.dart';
import '../models/user_model.dart';

class ProfileController extends GetxController {
  Rx<UserModel?> userProfile = Rx<UserModel?>(null);
  RxBool isLoading = true.obs;
  var userEvents = <Event>[].obs;

  // Dependencies
  final box = GetStorage();
  final usernameController = TextEditingController();
  final UserService userService = UserService();

  // Initialization
  @override
  void onInit() async {
    super.onInit();
    final int? userId = box.read<int>('user_id');
    if (userId != null) {
      await initializeProfile(userId);
    } else {
      print("Error: User ID not found in storage.");
    }
  }

  // Private method to initialize profile data
  Future<void> initializeProfile(int userId) async {
    String token = box.read<String>('token') ?? '';
    if (token.isEmpty) {
      print("Error: Token not found in storage.");
      return;
    }
    await fetchProfileData(userId);
    //await fetchUserEvents(userId);
  }

  // Fetch profile data
  Future<UserModel?> fetchProfileData(int userId) async {
    try {
      print("Fetching profile data for user ID: $userId");
      final profileData = await userService.fetchProfileData(userId);
      if (profileData != null) {
        print("Profile data retrieved successfully.");
        userProfile.value = profileData;
        return profileData;
      } else {
        print("No profile data found.");
        userProfile.value = null;
        return null;
      }
    } catch (e) {
      print("Error fetching profile data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshProfile() async {
    final int? userId = box.read<int>('user_id');
    if (userId != null) {
      await fetchProfileData(userId);
      userProfile.refresh();
    } else {
      print("Error: User ID not found in storage.");
    }
  }

  Future<List<String>> getUserInterests(int userId) async {
    try {
      var interests = await userService.getUserInterests(userId);

      if (interests != null && interests is List<String>) {
        return interests;
      } else {
        throw Exception('Invalid interests data received');
      }
    } catch (e) {
      print('Error occurred while fetching interests: $e');
      throw Exception('Failed to load interests');
    }
  }
}
