import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../controllers/email_controller.dart';

class UpdateEmail extends StatelessWidget {
  const UpdateEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateEmailController());
    return Scaffold(
      // Custom AppBar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          'Change Email',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please choose a valid email that is easy to recall.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MySizes.spaceBtwSections),

            // Text field and Button
            Form(
              key: controller.formKeyEmail,
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.email,
                    validator: (value) => MyValidator.validateEmail(value),
                    decoration: const InputDecoration(
                      labelText: MyTexts.email,
                      prefixIcon: Icon(Iconsax.message),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: MySizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateEmail();
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
