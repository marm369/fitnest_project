import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/buttons/square_button.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class ConfirmIdentityForm extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKeyStep2,
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
                  return Column(
                    children: [
                      SquareButton(
                        text: 'Front ID',
                        icon: Iconsax.camera,
                        onPressed: () {
                          controller.pickImage(controller.frontImagePath);
                        },
                        image: controller.frontImagePath.value.isNotEmpty
                            ? controller.frontImagePath.value
                            : null,
                        validator: (value) =>
                            MyValidator.validateFrontIdImage(value),
                      ),
                      SizedBox(height: MySizes.spaceBtwItems),
                      if (controller.frontImageMessageError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            controller.frontImageMessageError.value,
                            style: const TextStyle(
                              color: MyColors.red,
                              fontSize: MySizes.fontSizeSm,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  );
                }),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(() {
                  return Column(
                    children: [
                      SquareButton(
                        text: 'Back ID',
                        icon: Iconsax.camera,
                        onPressed: () {
                          controller.pickImage(controller.backImagePath);
                        },
                        image: controller.backImagePath.value.isNotEmpty
                            ? controller.backImagePath.value
                            : null,
                        validator: (value) =>
                            MyValidator.validateBackIdImage(value),
                      ),
                      SizedBox(height: MySizes.spaceBtwItems),
                      if (controller.backImageMessageError.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            controller.backImageMessageError.value,
                            style: const TextStyle(
                              color: MyColors.red,
                              fontSize: MySizes.fontSizeSm,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
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
