import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../features/authentication/screens/login/login.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SuccessScreen(
      image: MyImages.staticSuccessIllustration,
      title: 'Account Created Successfully!',
      subTitle: 'You can now start using the app and explore all its features.',
      onPressed: () {
        Get.to(() => const LoginScreen());
      },
    );
  }
}
