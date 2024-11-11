import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../data/services/signin_service.dart';
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
  }

  // Method for sign in
  Future<bool> emailAndPasswordSignIn() async {
    try {
      // Check Internet Connectivity
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        return false;
      }

      // Form Validation
      if (!formKeyLogin.currentState!.validate()) {
        return false;
      }
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', emailOrUsername.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      final SignInService _loginService = SignInService();
      String? token = await _loginService.signIn({
        'login': emailOrUsername.text.trim(),
        'password': password.text.trim(),
      });
      if (token != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
      return false;
    }
  }
}
