import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../controllers/phonenumber_controller.dart';

class UpdatePhoneNumber extends StatelessWidget {
  const UpdatePhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    final updatePhoneNumberController = Get.put(UpdatePhoneNumberController());
    return Scaffold(
      // Custom AppBar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          'Change Phone Number',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              'Provide us with your active Phone Number',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MySizes.spaceBtwSections),
            Form(
              key: updatePhoneNumberController.formKeyPhoneNumber,
              child: Column(
                children: [
                  TextFormField(
                    controller: updatePhoneNumberController.phoneNumber,
                    validator: (value) =>
                        MyValidator.validatePhoneNumber(value),
                    decoration: const InputDecoration(
                      labelText: MyTexts.phoneNo,
                      prefixIcon: Icon(Iconsax.user),
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
                  updatePhoneNumberController.updatePhoneNumber();
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
