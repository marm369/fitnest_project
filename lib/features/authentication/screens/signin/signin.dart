import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/signin_signup/form_divider.dart';
import '../../../../common/widgets/signin_signup/social_buttons.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/signin_form.dart';
import 'widgets/signin_header.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: SpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // Logo, Title & SubTitle
              SignInHeader(),
              // Form
              SignInForm(),
              // Footer
              //const SocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
