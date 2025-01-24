import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

import 'features/events/screens/create_event.dart';
import 'features/home/screens/home.dart';
import 'features/maps/screens/map_events.dart';
import 'features/participation/screens/participation_screen.dart';
import 'features/profile/screens/profile.dart';
import 'utils/helpers/helper_functions.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:fitnest/features/feedbacks/feedback_service.dart';
import 'package:fitnest/features/feedbacks/feedback_screen.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _LandingPageState();
}

class _LandingPageState extends State<NavigationMenu> {
  int selectedIndex = 0;
  final box = GetStorage();
  final FeedbackService _feedbackService = FeedbackService(); // Ajout FeedbackService
  List<dynamic> pages = [
    HomeScreen(),
    EventsMapPage(),
    EventScreen(),
    ParticipationScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    print("hhhhhhhhhh");
    _checkAndShowFeedback(); // Appel pour vérifier les feedbacks
  }

  Future<void> _checkAndShowFeedback() async {
    try {
      final finishedEvents = await _feedbackService.fetchEventsByUserId(box.read('user_id'));
      print('***************$finishedEvents');
      print('+++ ${box.read('user_id')}');
      if (finishedEvents.isNotEmpty) {
        _showFeedbackDialog(finishedEvents); // Affiche les feedbacks si nécessaire
      }
    } catch (e) {
      print('Erreur lors de la récupération des événements : $e');
    }
  }

  void _showFeedbackDialog(List<Map<String, dynamic>> events) {
    showDialog(
      context: context,
      builder: (context) {
        return FeedbackDialog(userId: box.read('user_id'), events: events);
      },
    );
  }

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
          color: dark
              ? Colors.white
              : Colors.blue, // Adjust color based on dark mode
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