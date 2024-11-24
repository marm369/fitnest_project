import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'features/authentication/screens/signin/signin.dart';
import 'navigation_menu.dart';
import 'test/test1.dart';
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
      home: isFirstTime ? OnBoardingScreen() : SignInScreen(),
    );
  }
}
