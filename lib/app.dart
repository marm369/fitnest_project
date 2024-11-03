import 'package:fitnest/features/authentication/screens/onboarding/onboarding.dart';
import 'package:fitnest/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: MyAppTheme.darkTheme,
      theme: MyAppTheme.lightTheme,
      home: const OnBoardingScreen(),
    );
  }
}
