import 'package:fitnest/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'utils/constants/colors.dart';
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  final bool isFirstTime;

  App({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: MyAppTheme.darkTheme,
      theme: MyAppTheme.lightTheme,
      home: isFirstTime ? OnBoardingScreen() : LoginScreen(),
    );
  }
}
