import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;

    return Positioned(
      bottom: MyDeviceUtils.getBottomNavigationBarHeight() + 100,
      left: MySizes.spaceBtwSections * 5,
      child: SmoothPageIndicator(
        controller: controller.pageController,
        count: 4,
        effect: const ExpandingDotsEffect(
          activeDotColor: Colors.blue,
          dotColor: MyColors.softGrey,
          dotHeight: 10,
          dotWidth: 10,
          expansionFactor: 4,
          spacing: 10,
        ),
      ),
    );
  }
}
