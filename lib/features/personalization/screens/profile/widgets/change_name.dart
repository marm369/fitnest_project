import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/update_name_controller.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom Appbar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text('Change Name',
            style: Theme.of(context).textTheme.headlineSmall),
      ), // TAppBar
      body: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Headings
            Text(
              'Use real name for easy verification. This name will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ), // Text
            const SizedBox(height: MySizes.spaceBtwSections),

            /// Text field and Button
            Form(
                key: controller.updateUserNameFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.firstName,
                      validator: (value) =>
                          MyValidator.validateEmptyText('First name', value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: MyTexts.firstName,
                          prefixIcon: Icon(Iconsax.user)),
                    ), // TextFormField
                    const SizedBox(height: MySizes.spaceBtwInputFields),
                    TextFormField(
                      controller: controller.lastName,
                      validator: (value) =>
                          MyValidator.validateEmptyText('Last name', value),
                      expands: false,
                      decoration: const InputDecoration(
                          labelText: MyTexts.lastName,
                          prefixIcon: Icon(Iconsax.user)),
                    ), // TextFormField
                  ],
                )), // Column, Form
            const SizedBox(height: MySizes.spaceBtwSections),

            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () => controller.updateUserName(),
                  child: const Text('Save')),
            ), // Sized Box
          ],
        ),
      ),
    );
  }
}
