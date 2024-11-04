import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../navigation_menu.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../password_configuration/forget_password.dart';
import '../../signup/signup.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: MySizes.spaceBtwSections),
        child: Column(
          children: [
            // Email
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: MyTexts.email,
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwInputFields),

            // Password
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.password_check),
                labelText: MyTexts.password,
                suffixIcon: Icon(Iconsax.eye_slash),
              ), // InputDecoration
            ), // TextFormField

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
                onPressed: () => Get.to(() => NavigationMenu()),
                child: const Text(MyTexts.signIn),
              ),
            ),

            const SizedBox(height: MySizes.spaceBtwItems),

            // Create Account In Button
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
