import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/services/authentication/signin_service.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';
import '../../../../features/notifs/configs/notifications_configuration.dart';

class SignInController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final emailOrUsername = TextEditingController();
  final password = TextEditingController();

  final formKeyLogin = GlobalKey<FormState>();
  final NetworkManager networkManager = Get.put(NetworkManager());
  final SignInService loginService = SignInService();

  @override
  void onInit() {
    // emailOrUsername.text = localStorage.read<String>('REMEMBER_ME_EMAIL') ?? '';
    // password.text = localStorage.read<String>('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  // Method for sign in
  Future<String> emailAndPasswordSignIn() async {
    try {
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        return 'No internet connection. Please check your connection and try again.';
      }

      if (!formKeyLogin.currentState!.validate()) {
        return 'Form validation failed. Please ensure all required fields are filled out correctly.';
      }

      // Step 3: Optional Remember Me functionality (commented out for now)
      /*
    if (rememberMe.value) {
      localStorage.write('REMEMBER_ME_EMAIL', emailOrUsername.text.trim());
      localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
    }
    */

      String? token = await loginService.signIn({
        'login': emailOrUsername.text.trim(),
        'password': password.text.trim(),
      });

      if (token != null) {
        //configure notifications
        final storage = GetStorage();
        await configureNotifications( storage.read('user_id'));

        return 'Login successful!';
      } else {
        return 'Invalid credentials. Please check your login details and try again.';
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
      return 'An unexpected error occurred. Please try again later.';
    }
  }
}
