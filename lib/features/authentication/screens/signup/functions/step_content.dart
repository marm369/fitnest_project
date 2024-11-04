// widgets/step_content.dart
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class StepContent extends StatelessWidget {
  final String stepTitle;
  final Widget content;

  StepContent({
    required this.stepTitle,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(MySizes.spaceBtwItems),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              stepTitle,
              style: const TextStyle(
                  fontSize: MySizes.fontSizeLg, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: MySizes.defaultSpace),
            content,
          ],
        ),
      ),
    );
  }
}
