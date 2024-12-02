import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/services/authentication/signup_service.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/popups/loaders.dart';
import '../../controllers/signup/signup_controller.dart';
import '../../controllers/signup/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email, this.code});

  final String? email;
  final String? code;

  @override
  Widget build(BuildContext context) {
    final SignupController signupController = SignupController();
    final TextEditingController codeController = TextEditingController();

    // Fonction de vérification du code
    void _verifyCode() {
      String enteredCode = codeController.text;

      if (enteredCode.length == 4 && enteredCode == code) {
        Get.to(() => SuccessScreen(
              image: MyImages.staticSuccessIllustration,
              title: MyTexts.yourAccountCreatedTitle,
              subTitle: MyTexts.successScreenSubTitle,
            ));
      } else {
        // Si le code est incorrect, afficher un SnackBar
        Loaders.errorSnackBar(
            title: 'Verification Code incorrect',
            message: 'Check your email, and enter the correct code');
      }
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(CupertinoIcons.clear))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            children: [
              // Image
              Image(
                image: const AssetImage(MyImages.deliveredEmailIllustration),
                width: HelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),

              // Title & SubTitle
              Text(
                MyTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Text(
                email ?? '',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwItems),
              Text(
                MyTexts.confirmEmailSubTitle,
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: MySizes.spaceBtwSections),

              // Code Input Field
              TextField(
                controller: codeController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'Entrez le code à 4 chiffres',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems),

              // Verify Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifyCode,
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
