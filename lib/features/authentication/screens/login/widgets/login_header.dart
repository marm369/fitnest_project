import 'package:flutter/material.dart';
import 'package:fitnest/utils/constants/image_strings.dart';
import 'package:fitnest/utils/constants/sizes.dart';
import 'package:fitnest/utils/constants/text_strings.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 130,
          width: 180,
          image: AssetImage(MyImages.FNLargeLogo),
        ),
        Text(MyTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(
          height: MySizes.md,
        ),
        Text(MyTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
