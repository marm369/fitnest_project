import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/user_controller.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.find<UserController>(); // Get the UserController instance
    return Scaffold(
      appBar: AppBar(title: const Text('Re-Authenticate User')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey, // Form key for validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Email
                TextFormField(
                  controller:
                      controller.verifyEmail, // Controller for email field
                  validator: MyValidator.validateEmail, // Validator for email
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: MyTexts.email,
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),

                /// Password
                Obx(
                  () => TextFormField(
                    obscureText: controller
                        .hidePassword.value, // Toggle password visibility
                    controller: controller
                        .verifyPassword, // Controller for password field
                    validator: (value) => MyValidator.validateEmptyText(
                        'Password', value), // Validator for password
                    decoration: InputDecoration(
                      labelText: MyTexts.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.hidePassword.value = !controller
                              .hidePassword.value; // Toggle hide/show password
                        },
                        icon: Icon(controller.hidePassword.value
                            ? Iconsax.eye_slash
                            : Iconsax.eye), // Toggle icon
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: MySizes.spaceBtwSections),

                /// LOGIN Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.reAuthFormKey.currentState?.validate() ??
                          false) {
                        // Call controller function to verify user
                        // controller.verifyUser(); // Uncomment this line when the function is ready
                      }
                    },
                    child: const Text('Verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
