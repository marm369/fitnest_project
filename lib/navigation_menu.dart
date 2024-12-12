import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'features/events/screens/create_event.dart';
import 'features/home/screens/home.dart';
import 'features/maps/screens/map_events.dart';
import 'features/participation/screens/participation_screen.dart';
import 'features/profile/screens/profile.dart';
import 'utils/helpers/helper_functions.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _LandingPageState();
}

class _LandingPageState extends State<NavigationMenu> {
  int selectedIndex = 0;
  List<dynamic> pages = [
    HomeScreen(),
    EventsMapPage(),
    EventScreen(),
    ParticipationScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: dark ? Colors.black : Colors.white,
          activeColor: Colors.blue,
          initialActiveIndex: selectedIndex,
          elevation: 0,
          style: TabStyle.fixedCircle,
          color: dark ? Colors.white : Colors.blue,
          // Adjust color based on dark mode
          items: [
            TabItem(
              icon: Icon(
                Iconsax.home,
                color: dark
                    ? Colors.white
                    : Colors.black, // Icon color based on dark mode
              ),
              title: '',
            ),
            TabItem(
              icon: Icon(
                Iconsax.map,
                color: dark
                    ? Colors.white
                    : Colors.black, // Icon color based on dark mode
              ),
              title: '',
            ),
            TabItem(
              icon: Icon(
                Iconsax.add,
                color: dark
                    ? Colors.black
                    : Colors.white, // Icon color based on dark mode
              ),
              title: '',
            ),
            TabItem(
              icon: Icon(
                Iconsax.chart,
                color: dark
                    ? Colors.white
                    : Colors.black, // Icon color based on dark mode
              ),
              title: '',
            ),
            TabItem(
              icon: Icon(
                Iconsax.user,
                color: dark
                    ? Colors.white
                    : Colors.black, // Icon color based on dark mode
              ),
              title: '',
            ),
          ],
          onTap: (int i) {
            setState(() {
              selectedIndex = i;
            });
          },
        ));
  }
}
