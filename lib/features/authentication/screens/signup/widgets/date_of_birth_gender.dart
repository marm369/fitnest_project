import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/date_of_birth_controller.dart';
import '../../../controllers/signup/signup_controller.dart';

class DateOfBirthGenderForm extends StatelessWidget {
  final DateOfBirthGenderController controller =
      Get.put(DateOfBirthGenderController());
  final SignupController controller1 = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          //controller : controller1.birthDate,
          readOnly: true,
          decoration: const InputDecoration(
            labelText: MyTexts.dateOfBirth,
            prefixIcon: Icon(Iconsax.calendar),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          onTap: () => controller.selectDate(context),
          controller: controller.dateController,
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        DropdownButtonFormField<String>(
          value: controller.selectedGender.value.isNotEmpty
              ? controller.selectedGender.value
              : null,
          items: ['Female', 'Male']
              .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: (newValue) => controller.setGender(newValue ?? ''),
          decoration: const InputDecoration(
            labelText: MyTexts.selectGender,
            prefixIcon: Icon(Iconsax.user),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          dropdownColor: Colors.white,
          style: TextStyle(
            color: Colors.blue,
            fontSize: MySizes.fontSizeMd,
          ),
        )
      ],
    );
  }
}
