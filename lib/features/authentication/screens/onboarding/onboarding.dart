import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';
import 'widgets/onboarding_dot_navigation.dart';
import 'widgets/onboarding_next_button.dart';
import 'widgets/onboarding_page.dart';
import 'widgets/onboarding_skip.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnBoardingController());
    return Scaffold(
      body: Stack(
        children: [
          // Horizontal Scrollabale Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: MyImages.onBoardingImage1,
                title: MyTexts.onBoardingTitle1,
                subtitle: MyTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: MyImages.onBoardingImage2,
                title: MyTexts.onBoardingTitle2,
                subtitle: MyTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: MyImages.onBoardingImage3,
                title: MyTexts.onBoardingTitle3,
                subtitle: MyTexts.onBoardingSubTitle3,
              ),
              OnBoardingPage(
                image: MyImages.onBoardingImage4,
                title: MyTexts.onBoardingTitle4,
                subtitle: MyTexts.onBoardingSubTitle4,
              ),
            ],
          ),

          // Skip Button
          const OnBoardingSkip(),

          // Dot Navigation SmoothPageIndicator
          const OnBoardingDotNavigation(),

          // Circular Button
          const OnBoardingNextButton()
        ],
      ),
    );
  }
}
