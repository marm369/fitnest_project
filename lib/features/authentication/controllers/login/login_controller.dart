import 'package:fitnest/features/network_manager.dart';
import 'package:fitnest/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/loaders.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  //final userController = Get.put(UserController());

  @override
  void onInit() {
    email.text = localStorage.read<String>('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read<String>('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  } // Email and Password SignIn

  Future<void> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'Logging you in', MyImages.loadingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login user using Email & Password Authentication
      //final userCredentials = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // Remove Loader
      FullScreenLoader.stopLoading();

      // Redirect
      //AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  Future<void> googleSignIn() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Logging you in...', MyImages.loadingIllustration);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      //final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      // await userController.saveUserRecord(userCredentials);

      FullScreenLoader.stopLoading();

      //AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}
