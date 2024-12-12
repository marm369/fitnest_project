import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../controllers/home_controller.dart';
import 'widgets/event_card.dart';

class EventScrollWidget extends StatelessWidget {
  EventScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    final HomeController homeController = Get.put(HomeController());
    return Obx(() {
      if (homeController.events.isEmpty) {
        return Container(
            height: MySizes.xs, color: dark ? Colors.black : Colors.white);
      } else {
        // Retourner la liste des événements dans un `SizedBox` avec une hauteur de 200
        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.events.length,
            itemBuilder: (context, index) {
              final event = homeController.events[index];

              // Construction de la carte d'événement
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
                child: SizedBox(
                  width: 250,
                  child: EventCard(
                    id: event.eventId ?? 0,
                    eventImage: event.eventImage ?? '',
                    title: event.eventName ?? 'No Title',
                    date: event.eventDate,
                    profileImage: event.organizerImage ?? '',
                    organizer: event.organizerName ?? 'Unknown',
                    organizerId: event.organizerId ?? 0,
                  ),
                ),
              );
            },
          ),
        );
      }
    });
  }
}
