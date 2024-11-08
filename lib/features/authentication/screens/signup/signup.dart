// SignupScreen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';
import '../../controllers/signup/signup_controller.dart';
import 'widgets/additional_infos_form.dart';
import 'widgets/confirm_identity.dart';
import 'widgets/signup_form.dart';
import 'functions/step_content.dart';
import 'functions/step_indicator.dart'; // Chemin vers les constantes MyTexts, MySizes, etc.

class SignupScreen extends StatelessWidget {
  final SignupController controller = Get.put(SignupController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyTexts.signupTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: MySizes.spaceBtwItems),
          // Indicateur d'étape
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(() => StepIndicator(
                    step: 0,
                    label: "Personal Details",
                    isActive: controller.currentStep.value == 0,
                  )),
              Obx(() => StepIndicator(
                    step: 1,
                    label: "ID Proof",
                    isActive: controller.currentStep.value == 1,
                  )),
              Obx(() => StepIndicator(
                    step: 2,
                    label: "Additional Infos",
                    isActive: controller.currentStep.value == 2,
                  )),
            ],
          ),
          const SizedBox(height: MySizes.spaceBtwItems),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                StepContent(
                  stepTitle: MyTexts.personalDetails,
                  content: SignupForm(),
                ),
                StepContent(
                  stepTitle: MyTexts.idProofTitle,
                  content: ConfirmIdentityForm(),
                ),
                StepContent(
                  stepTitle: MyTexts.additionalInfos,
                  content: AdditionalInfosForm(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(MySizes.spaceBtwItems),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => controller.currentStep.value > 0
                      ? ElevatedButton(
                          onPressed: controller.previousStep,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: MySizes.md,
                                vertical: MySizes
                                    .md), // ajustez les valeurs selon vos besoins
                          ),
                          child: Text("Previous"),
                        )
                      : SizedBox.shrink(),
                ),
                const SizedBox(width: MySizes.sm),
                Obx(
                  () => ElevatedButton(
                    onPressed: controller.currentStep.value == 2
                        ? () {
                            if (controller.formKeyStep3.currentState!
                                .validate()) {
                              controller.signup();
                            } else {
                              Loaders.warningSnackBar(
                                title: 'Validation Error',
                                message:
                                    'Please fill in all the fields correctly for Step 3.',
                              );
                            }
                          }
                        : controller.nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: MySizes.md, vertical: MySizes.md),
                    ),
                    child: Text(
                        controller.currentStep.value == 2 ? "Submit" : "Next"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
