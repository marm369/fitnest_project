import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';
import '../../screens/password_configuration/reset_password.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  final email = TextEditingController();

  sendPasswordResetEmail() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', MyImages.loadingIllustration);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      /*
      if (!forgetPasswordFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }
      */

      // await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);

      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your request...', MyImages.loadingIllustration);

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      FullScreenLoader.stopLoading();

      Loaders.successSnackBar(
          title: 'Email Sent',
          message: 'Email Link Sent to Reset your Password'.tr);
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}
