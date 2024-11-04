import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'reset_password.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: dark ? Colors.white : Colors.black, // Couleur selon le mode
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.all(MySizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Headings
                Text(MyTexts.forgetPasswordTitle,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: MySizes.spaceBtwItems),
                Text(MyTexts.forgetPasswordSubTitle,
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: MySizes.spaceBtwSections * 2),

                // Text field
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: MyTexts.email,
                      prefixIcon: Icon(Iconsax.direct_right)),
                ),

                const SizedBox(height: MySizes.spaceBtwSections),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.off(() => const ResetPasswordScreen(
                          email: "minouarim@gmail.com")),
                      child: const Text(MyTexts.submit)),
                ),
              ],
            )));
  }
}
