import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/onboarding/onboarding.dart';
import 'features/authentication/screens/signin/signin.dart';
import 'features/notifs/screens/display_notifs.dart';
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
      //home: const NotifScreen(userId: 1,), // Pass a valid userId dynamically.
    );
  }

}
