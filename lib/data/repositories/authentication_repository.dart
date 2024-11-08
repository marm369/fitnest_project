import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../features/authentication/screens/onboarding/onboarding.dart';
import '../../features/authentication/screens/signin/signin.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  // Variables
  final devicesStorage = GetStorage();

  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  screenRedirect() async {
    // Local Storage
    devicesStorage.writeIfNull('IsFirstTime', true);
    devicesStorage.read('IsFirstTime') != true
        ? Get.offAll(() => const SignInScreen())
        : Get.offAll(const OnBoardingScreen());
  }
}
