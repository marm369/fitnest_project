import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class AdditionalInfosForm extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyStep3,
      child: Padding(
        padding: const EdgeInsets.all(MySizes.xs),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Date of Birth and Gender
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: controller.birthDate,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: MyTexts.dateOfBirth,
                    prefixIcon: Icon(Iconsax.calendar),
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  onTap: () => controller.selectDate(context),
                  validator: (value) =>
                      MyValidator.validateEmptyText('Date of Birth', value),
                ),
                SizedBox(height: MySizes.spaceBtwItems),
                Obx(
                  () => DropdownButtonFormField<String>(
                    value: controller.selectedGender.value.isNotEmpty
                        ? controller.selectedGender.value
                        : null,
                    items: ['Female', 'Male']
                        .map((gender) => DropdownMenuItem<String>(
                              value: gender,
                              child: Text(gender),
                            ))
                        .toList(),
                    onChanged: (newValue) =>
                        controller.setGender(newValue ?? ''),
                    decoration: const InputDecoration(
                      labelText: MyTexts.selectGender,
                      prefixIcon: Icon(Iconsax.user),
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                    ),
                    dropdownColor: Colors.white,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: MySizes.fontSizeMd,
                    ),
                    validator: (value) =>
                        MyValidator.validateEmptyText('Gender', value),
                  ),
                )
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),

            // Section 2: Interests
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyTexts.interests,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: MySizes.spaceBtwItems),
                Obx(
                  () => Wrap(
                    spacing: MySizes.sm,
                    runSpacing: MySizes.xs / 2,
                    children:
                        List.generate(controller.interests.length, (index) {
                      final interest = controller.interests[index]['name'];
                      final isSelected =
                          controller.selectedInterests[interest] ?? false;
                      final iconData = controller.interests[index]['icon'];

                      return GestureDetector(
                        onTap: () => controller.toggleInterest(interest),
                        child: Container(
                          padding: EdgeInsets.all(MySizes.lg / 2),
                          margin: EdgeInsets.symmetric(vertical: MySizes.xs),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF90CAF9)
                                : Colors.grey[50],
                            border: Border.all(
                              color: isSelected
                                  ? MyColors.primaryBackground
                                  : MyColors.borderPrimary,
                            ),
                            borderRadius:
                                BorderRadius.circular(MySizes.borderRadiusMd),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                iconData,
                                color: isSelected
                                    ? MyColors.primaryBackground
                                    : MyColors.borderPrimary,
                              ),
                              SizedBox(width: MySizes.xs),
                              Text(
                                interest,
                                style: TextStyle(
                                  fontSize: MySizes.fontSizeSm,
                                  color: isSelected
                                      ? MyColors.primaryBackground
                                      : Colors.black54,
                                ),
                              ),
                              SizedBox(width: MySizes.xs),
                              Icon(
                                isSelected ? Icons.remove : Icons.add,
                                color: isSelected
                                    ? MyColors.primaryBackground
                                    : MyColors.borderPrimary,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: MySizes.spaceBtwItems),
            // Section 3: Goals
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MyTexts.lookingFor,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: MySizes.spaceBtwItems),
                Obx(
                  () => Wrap(
                    spacing: MySizes.md,
                    runSpacing: MySizes.md,
                    children: List.generate(controller.goals.length, (index) {
                      final goal = controller.goals[index];
                      final isSelected =
                          controller.selectedGoals[goal] ?? false;
                      return GestureDetector(
                        onTap: () => controller.toggleGoal(goal),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: MySizes.lg / 2, vertical: MySizes.sm),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue[50] : Colors.white,
                            border: Border.all(
                              color:
                                  isSelected ? Colors.blue : Colors.grey[400]!,
                            ),
                            borderRadius:
                                BorderRadius.circular(MySizes.borderRadiusMd),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.circle_outlined,
                                color:
                                    isSelected ? Colors.blue : Colors.grey[600],
                              ),
                              SizedBox(width: MySizes.sm),
                              Text(
                                goal,
                                style: TextStyle(
                                  fontSize: MySizes.fontSizeSm,
                                  color: isSelected
                                      ? Colors.blue[800]
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
