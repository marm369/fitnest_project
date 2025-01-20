import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'features/authentication/screens/signin/signin.dart';
import 'features/home/screens/home.dart';
import 'features/profile/screens/profile.dart';
<<<<<<< HEAD
=======
import 'features/tracking/screens/tracking_organizer_screen.dart';
import 'navigation_menu.dart';
>>>>>>> e8d5a49 (feedback and participation services)
import 'utils/theme/theme.dart';

class App extends StatelessWidget {
  final bool isFirstTime;

  App({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: MyAppTheme.darkTheme,
      theme: MyAppTheme.lightTheme,
      routes: {
        '/profile': (acontext) => ProfileScreen(),
        '/signin': (context) => SignInScreen(),
        '/home': (context) => HomeScreen(),
        '/buttomNavigationBar': (context) => NavigationMenu(),
      },
      home: OnBoardingScreen() ,
    );
  }
}
