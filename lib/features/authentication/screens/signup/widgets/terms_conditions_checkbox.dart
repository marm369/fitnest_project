import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../controllers/signup/signup_controller.dart';

class TermsAndConditionsCheckbox extends StatelessWidget {
  const TermsAndConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = HelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Obx(() => Checkbox(
                    value: controller.privacyPolicy.value,
                    onChanged: (value) {
                      controller.privacyPolicy.value = value!;
                      // Validation mise à jour directement après le changement
                      controller.errorMessage.value =
                          MyValidator.validateAcceptTerms(value)!;
                    },
                  )),
            ),
            const SizedBox(width: MySizes.spaceBtwItems),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: MyTexts.iAgreeTo,
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                    text: MyTexts.privacyPolicy,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: dark ? MyColors.white : MyColors.primary),
                  ),
                  TextSpan(
                      text: MyTexts.and,
                      style: Theme.of(context).textTheme.bodySmall),
                  TextSpan(
                    text: MyTexts.termsOfUse,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .apply(color: dark ? MyColors.white : MyColors.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
        // Affiche le message d'erreur conditionnellement
        Obx(
          () => controller.errorMessage.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    controller.errorMessage.value,
                    style: TextStyle(
                        color: MyColors.red, fontSize: MySizes.fontSizeMd),
                  ),
                )
              : SizedBox.shrink(), // Cache le widget si aucun message d'erreur
        ),
      ],
    );
  }
}
