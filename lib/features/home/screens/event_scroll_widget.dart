import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/cards/event_card.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/popups/loaders.dart';
import '../controllers/home_controller.dart';

class EventScrollWidget extends StatelessWidget {
  EventScrollWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instance du contrôleur
    final HomeController homeController = Get.put(HomeController());
    return Obx(() {
      // Vérifie si la liste d'événements est vide
      if (homeController.events.isEmpty) {
        // Afficher une barre d'erreur uniquement si aucun événement n'est trouvé
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Loaders.errorSnackBar(
            title: "No Events Found",
            message:
                "There are currently no events available for this category. Please check back later or explore other categories.",
          );
        });
        // Retourner un `SizedBox` avec une hauteur de 10
        return SizedBox(height: MySizes.xs);
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
                    eventImage: event.eventImage ?? '',
                    title: event.eventName ?? 'No Title',
                    date: event.eventDate,
                    profileImage: event.organizerImage ?? '',
                    organizer: event.organizerName ?? 'Unknown',
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
