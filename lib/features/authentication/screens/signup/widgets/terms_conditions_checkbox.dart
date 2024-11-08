import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';
import 'terms_dialog.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.privacyPolicy.value,
                  onChanged: (value) {
                    controller.privacyPolicy.value = value!;
                    // Update validation immediately after change
                    controller.privacyPolicyMessageError.value =
                        MyValidator.validateAcceptTerms(value) ?? '';
                    controller.update();
                  },
                ),
              ),
              const SizedBox(width: MySizes.spaceBtwItems),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: MyTexts.iAgreeTo,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: MyTexts.privacyPolicy,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? MyColors.white : MyColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showDialog(context, 'Privacy Policy');
                        },
                    ),
                    TextSpan(
                      text: MyTexts.and,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextSpan(
                      text: MyTexts.termsOfUse,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: dark ? MyColors.white : MyColors.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _showDialog(context, 'Terms of Use');
                        },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: MySizes.spaceBtwItems),
        Obx(
          () {
            if (controller.privacyPolicyMessageError.value.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  controller.privacyPolicyMessageError.value,
                  style: const TextStyle(
                    color: MyColors.red,
                    fontSize: MySizes.fontSizeSm,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ],
    );
  }

  void _showDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TermsDialog(title: title);
      },
    );
  }
}
