import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signin/signin_controller.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class SignInForm extends StatelessWidget {
  SignInForm({
    super.key,
  });
  final SignInController controller = Get.put(SignInController());
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyLogin,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              controller: controller.emailOrUsername,
              validator: (value) =>
                  MyValidator.validateEmptyText('Email or Username', value),
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: MyTexts.emailOrUsername,
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),
            // Password
            Obx(
              () => TextFormField(
                validator: (value) =>
                    MyValidator.validateEmptyText('Password', value),
                controller: controller.password,
                obscureText: controller.hidePassword.value,
                decoration: InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: MyTexts.password,
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(
                      controller.hidePassword.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                    ),
                  ),
                ),
              ),
            ),
// TextFormField
            const SizedBox(height: MySizes.spaceBtwInputFields / 2),
            // Remember Me & Forget password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Remember Me
                Row(
                  children: [
                    Checkbox(value: true, onChanged: (value) => {}),
                    const Text(MyTexts.rememberMe),
                  ],
                ),
                // Forget Password
                TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(MyTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwSections),
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Appelez la fonction d'authentification pour vérifier si l'utilisateur peut se connecter
                  bool isAuthenticated =
                      await controller.emailAndPasswordSignIn();

                  if (isAuthenticated) {
                    // Si l'utilisateur est authentifié, naviguez vers la page principale ou d'accueil
                    Get.to(() =>
                        NavigationMenu()); // Remplacez 'HomeScreen' par la page vers laquelle vous voulez naviguer
                  } else {
                    // Si l'utilisateur n'est pas authentifié, affichez un message d'erreur
                    Loaders.errorSnackBar(
                      title: 'Authentication Error',
                      message: 'Incorrect login or password.',
                    );
                  }
                },
                child: const Text(
                  'Sign In',
                  style: TextStyle(
                    fontSize: MySizes.fontSizeMd,
                  ),
                ),
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            // Create Account Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.to(() => SignupScreen()),
                child: const Text(MyTexts.createAccount),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
