import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../controllers/firstname_controller.dart';
import '../../controllers/profile_controller.dart';

class UpdateFirstName extends StatelessWidget {
  const UpdateFirstName({super.key});

  @override
  Widget build(BuildContext context) {
    final updateFirstNameController = Get.put(UpdateFirstNameController());
    return Scaffold(
      // Custom AppBar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text(
          'Change First Name',
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
              'Provide us with your First Name',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MySizes.spaceBtwSections),

            // Text field and Button
            Form(
              // If using a key, uncomment the next line
              key: updateFirstNameController.formKeyFirstName,
              child: Column(
                children: [
                  TextFormField(
                    // Uncomment and set controller if needed
                    controller: updateFirstNameController.firstName,
                    validator: (value) =>
                        MyValidator.validateEmptyText("First Name", value),
                    decoration: const InputDecoration(
                      labelText: MyTexts.firstName,
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
                  updateFirstNameController.updateFirstName();
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
