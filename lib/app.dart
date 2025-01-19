import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/authentication/screens/onboarding/onboarding.dart';
import 'features/authentication/screens/signin/signin.dart';
import 'features/home/screens/home.dart';
import 'features/profile/screens/profile.dart';
import 'features/tracking/screens/tracking_organizer_screen.dart';
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
      routes: {
        '/profile': (acontext) => ProfileScreen(),
        '/signin': (context) => SignInScreen(),
        '/home': (context) => HomeScreen(),
      },
      home: SignInScreen() ,
    );
  }
}
