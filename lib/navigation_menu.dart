import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'features/dashboard/dashboard.dart';
import 'features/events/create_event.dart';
import 'features/home/screens/home.dart';
import 'features/maps/screens/map.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

import 'features/profile/screens/profile.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _LandingPageState();
}

class _LandingPageState extends State<NavigationMenu> {
  int selectedIndex = 0;
  List<dynamic> pages = [
    HomeScreen(),
    MapScreen(),
    EventForm(),
    const DashboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[selectedIndex],
        bottomNavigationBar: ConvexAppBar(
          backgroundColor: Colors.white,
          activeColor: Colors.blue,
          initialActiveIndex: selectedIndex,
          elevation: 0,
          style: TabStyle.fixedCircle,
          color: Colors.blue,
          items: [
            TabItem(icon: Icon(Iconsax.home), title: ''),
            TabItem(icon: Icon(Iconsax.map), title: ''),
            const TabItem(icon: Icons.add, title: ''),
            TabItem(icon: Icon(Iconsax.chart), title: ''),
            TabItem(icon: Icon(Iconsax.user), title: ''),
          ],
          onTap: (int i) {
            setState(() {
              selectedIndex = i;
            });
          },
        ));
  }
}
