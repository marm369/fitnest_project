import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/buttons/square_button.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/confirm_identity_controller.dart';
import '../../../controllers/signup/signup_controller.dart';

class ConfirmIdentityForm extends StatelessWidget {
  final ConfirmIdentityController controller1 =
      Get.put(ConfirmIdentityController());
  final SignupController controller2 = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller2.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          Text(
            MyTexts.idProof,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: MySizes.spaceBtwItems),
          Row(
            children: [
              Expanded(
                child: Obx(() {
                  return SquareButton(
                    text: 'Front ID',
                    icon: Iconsax.camera,
                    onPressed: controller1.pickFrontImage,
                    image: controller1.frontImagePath.value.isNotEmpty
                        ? controller1.frontImagePath.value
                        : null,
                    validator: (value) => MyValidator.validateImagePath(
                        value), // Pass an empty string if no image is selected
                  );
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  return SquareButton(
                    text: 'Back ID',
                    icon: Iconsax.camera,
                    onPressed: controller1.pickBackImage,
                    image: controller1.backImagePath.value.isNotEmpty
                        ? controller1.backImagePath.value
                        : null,
                    validator: (value) => MyValidator.validateImagePath(
                        value), // Pass an empty string if no image is selected
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: MySizes.spaceBtwItems),
        ],
      ),
    );
  }
}
