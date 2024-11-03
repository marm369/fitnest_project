import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/signup_controller.dart';
import '../../../../../utils/validators/validation.dart';
import 'confirm_identity_form.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              // Champ de First Name
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      MyValidator.validateEmptyText('First Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: MyTexts.firstName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
              const SizedBox(width: MySizes.spaceBtwInputFields),
              // Champ de Last Name
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      MyValidator.validateEmptyText('Last Name', value),
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: MyTexts.lastName,
                    prefixIcon: Icon(Iconsax.user),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: MySizes.spaceBtwInputFields,
          ),
          // Champ de User Name
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                MyValidator.validateEmptyText('User Name', value),
            expands: false,
            decoration: const InputDecoration(
              labelText: MyTexts.username,
              prefixIcon: Icon(Iconsax.user_edit),
            ),
          ),
          const SizedBox(
            height: MySizes.spaceBtwInputFields,
          ),
          // Champ de E-mail
          TextFormField(
            controller: controller.email,
            validator: (value) => MyValidator.validateEmail(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: MyTexts.email,
              prefixIcon: Icon(Iconsax.direct),
            ),
          ),
          const SizedBox(
            height: MySizes.spaceBtwInputFields,
          ),
          // Champ de Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => MyValidator.validatePhoneNumber(value),
            expands: false,
            decoration: const InputDecoration(
              labelText: MyTexts.phoneNo,
              prefixIcon: Icon(Iconsax.call),
            ),
          ),
          const SizedBox(
            height: MySizes.spaceBtwInputFields,
          ),
          // Champs de Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => MyValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                  labelText: MyTexts.password,
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  )),
            ),
          ),
          const SizedBox(
            height: MySizes.spaceBtwInputFields,
          ),
          // Champ de Confirmation de Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => MyValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                  labelText: MyTexts.confirmPassword,
                  prefixIcon: Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye),
                  )),
            ),
          ),
          const SizedBox(
            height: MySizes.spaceBtwSections,
          ),
          // Le bouton "Next" pour passer à la deuxième partie du formulaire concernant l'identité
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                // On a commenter le test sur la validation de formulaire pour passer à la deuxième page sans remplir le formulaire
                onPressed: () {
                  //if (controller.signupFormKey.currentState!.validate()) {
                  // Proceed to next step if the form is valid
                  Get.to(() => const ConfirmIdentityForm());
                  //}
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: MyColors.king,
                  side: const BorderSide(color: MyColors.king, width: 2),
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  textStyle: const TextStyle(fontSize: 18), // Style du texte
                ),
                child: const Text(MyTexts.next),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
