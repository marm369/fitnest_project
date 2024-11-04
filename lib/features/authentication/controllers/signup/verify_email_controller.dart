import 'dart:async';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  @override
  void onInit() {
    sendEmailVerification();
    setTimeForAutoRedirect();
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

  setTimeForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        /*
        if (user?.emailVerified ?? false) {
          timer.cancel();
          Get.off(
            () => SuccessScreen(
              image: MyImages.staticSuccessIllustration,
              title: MyTexts.yourAccountCreatedTitle,
              subTitle: MyTexts.yourAccountCreatedSubTitle,
              onPressed: () {},
            ),
          );
        }

         */
      },
    );
  }

  // Manually Chack if Email Verifed
  checkEmailVerificationStatus() async {
    /*
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(
        () => SuccessScreen(
          image: MyImages.staticSuccessIllustration,
          title: MyTexts.yourAccountCreatedTitle,
          subTitle: MyTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect(),
        ),
      );


    }
  }

     */
  }
}
