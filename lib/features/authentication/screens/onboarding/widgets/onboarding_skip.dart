import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool dark = HelperFunctions.isDarkMode(context);

    return Positioned(
      top: MyDeviceUtils.getAppBarHeight(),
      right: MySizes.defaultSpace,
      child: TextButton(
        onPressed: () => OnBoardingController.instance.skipPage(),
        style: TextButton.styleFrom(
          backgroundColor: dark ? MyColors.black : MyColors.white,
          foregroundColor: dark ? MyColors.white : MyColors.black,
          padding: const EdgeInsets.symmetric(
            vertical: MySizes.sm,
            horizontal: MySizes.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySizes.sm),
            side: BorderSide(
              color: dark ? MyColors.white : Colors.blue,
              width: MySizes.xs / 2,
            ),
          ),
        ).copyWith(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.hovered)) {
                return MyColors.primaryBackground;
              }
              return null;
            },
          ),
        ),
        child: const Text(
          'Skip',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
