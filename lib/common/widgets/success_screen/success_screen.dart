import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/authentication/signup_service.dart';
import '../../../features/authentication/screens/signin/signin.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../styles/spacing_styles.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle});
  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              // Image
              Image(
                image: AssetImage(image),
                width: HelperFunctions.screenWidth() * 0.5,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              // Title & SubTitle
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Text(
                '',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const SignInScreen()),
                  child: const Text(MyTexts.tcontinue),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
