import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/cards/event_card.dart';
import '../controllers/home_controller.dart';

class EventScrollWidget extends StatelessWidget {
  EventScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instance du contrôleur
    final HomeController homeController = Get.put(HomeController());

    return SizedBox(
      height: 200,
      child: Obx(() {
        // Vérifie si la liste d'événements est vide
        if (homeController.events.isEmpty) {
          return const Center(
            child: Text('No events available.'),
          );
        }

        return ListView.builder(
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
                  eventImage: event.eventImage ?? '', // Image de l'événement
                  title: event.eventName ?? 'No Title', // Titre de l'événement
                  date: event.eventDate ?? 'No Date', // Date de début
                  profileImage:
                      event.organiserImage ?? '', // Image de l'organisateur
                  organizer:
                      event.organiserName ?? 'Unknown', // Nom de l'organisateur
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
