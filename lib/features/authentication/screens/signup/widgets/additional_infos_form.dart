import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';
import 'date_of_birth_gender.dart';
import 'interests.dart';
import 'looking_for_form.dart';

class AdditionalInfosForm extends StatefulWidget {
  @override
  _AdditionalInfosFormState createState() => _AdditionalInfosFormState();
}

class _AdditionalInfosFormState extends State<AdditionalInfosForm> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Date of Birth and Gender
          DateOfBirthGenderForm(),
          const SizedBox(height: MySizes.spaceBtwItems),
          // Section 2: Interests
          InterestsForm(),
          const SizedBox(height: MySizes.spaceBtwItems),
          // Section 3: Goals
          LookingForForm(),
        ],
      ),
    );
  }
}
