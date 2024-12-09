import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../authentication/controllers/signup/signup_controller.dart';
import '../../controllers/dateofbirth_controller.dart';

class UpdateDateOfBirth extends StatelessWidget {
  const UpdateDateOfBirth({super.key});

  @override
  Widget build(BuildContext context) {
    final updateDateOfBirthController = Get.put(UpdateDateOfBirthController());
    return Scaffold(
      // Custom AppBar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          'Change Your Date Of Birth',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: updateDateOfBirthController.formKeyDateOfBirth,
              child: Column(
                children: [
                  TextFormField(
                    controller: updateDateOfBirthController.dateOfBirth,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: MyTexts.dateOfBirth,
                      prefixIcon: Icon(Iconsax.calendar),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    onTap: () =>
                        updateDateOfBirthController.selectDate(context),
                    validator: (value) =>
                        MyValidator.validateEmptyText('Date of Birth', value),
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
                  updateDateOfBirthController.updateDateOfBirth();
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
