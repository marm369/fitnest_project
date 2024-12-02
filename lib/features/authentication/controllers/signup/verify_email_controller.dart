import 'dart:async';
import 'package:get/get.dart';

import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    super.onInit();
  }

  sendEmailVerification() async {
    try {
      // await AuthenticationRepository.instance.sendEmailVerification();
      Loaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please Check your inbox and verify your email.');
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }
}
