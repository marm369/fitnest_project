import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo, Title & SubTitle
              LoginHeader(),
              // Form
              const LoginForm(),
              // Divider
              FormDivider(dividerText: MyTexts.orSignInWith.capitalize!),
              const SizedBox(
                height: MySizes.spaceBtwItems,
              ),
              // Footer
              const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
