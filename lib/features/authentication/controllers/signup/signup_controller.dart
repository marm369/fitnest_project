import 'package:fitnest/utils/constants/image_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final firstName = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final personalPhoto = TextEditingController();
  final identityCard = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  void signup() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog(
          'We are processing your information ...',
          MyImages.loadingIllustration);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }

      // form Validation
      if (!signupFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        Loaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'In order to create an account, you must read and accept the Privacy Policy & Terms of Use.');
        return;
      }
      FullScreenLoader.stopLoading();

      // Show Success Message
      Loaders.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');

      // Move to Verify Email Screen
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
