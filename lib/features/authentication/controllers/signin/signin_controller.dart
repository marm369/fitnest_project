import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../data/services/signin_service.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';

class SignInController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final emailOrUsername = TextEditingController();
  final password = TextEditingController();

  final formKeyLogin = GlobalKey<FormState>();
  final NetworkManager networkManager = Get.put(NetworkManager());

  @override
  void onInit() {
    emailOrUsername.text = localStorage.read<String>('REMEMBER_ME_EMAIL') ?? '';
    password.text = localStorage.read<String>('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  } // Email and Password SignIn

  Future<bool> emailAndPasswordSignIn() async {
    try {
      // Start Loading
      // FullScreenLoader.openLoadingDialog(
      //    'Logging you in', MyImages.loadingIllustration);

      // Check Internet Connectivity
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        // FullScreenLoader.stopLoading();
        return false; // Pas de connexion Internet
      }

      // Form Validation
      if (!formKeyLogin.currentState!.validate()) {
        // FullScreenLoader.stopLoading();
        return false; // Formulaire invalide
      }

      // Save Data if Remember Me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', emailOrUsername.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final SignInService _loginService = SignInService();
      String? token = await _loginService.signIn({
        'login': emailOrUsername.text.trim(),
        'password': password.text.trim(),
      });

      // Stop Loading
      // FullScreenLoader.stopLoading();

      if (token != null) {
        // Authentification réussie, on peut continuer
        return true;
      } else {
        return false; // Authentification échouée
      }
    } catch (e) {
      // FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
      return false; // Erreur pendant le processus
    }
  }
}
