import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import 'widgets/signup_form.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                MyTexts.signupTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: MySizes.spaceBtwInputFields),
              // Form
              const SignupForm(),
              const SizedBox(
                height: MySizes.spaceBtwSections,
              ),
              // Divider
              FormDivider(dividerText: MyTexts.orSignUpWith.capitalize!),
              const SizedBox(
                height: MySizes.spaceBtwSections,
              ),
              // Social Buttons
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
