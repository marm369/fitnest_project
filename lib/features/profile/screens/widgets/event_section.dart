import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../events/models/event.dart';
import '../../../events/screens/detail_event.dart';

class EventsSectionWidget extends StatelessWidget {
  final Future<List<Event>> futureEvents;

  const EventsSectionWidget({required this.futureEvents, Key? key})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
            child: Text(
              "The organized events :",
              style: TextStyle(
                fontSize:
                    16.0, // Vous pouvez remplacer MySizes.fontSizeMd par un nombre
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
          ),
          FutureBuilder<List<Event>>(
            future: futureEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur : ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Vous n'avez organisé aucun événement."),
                );
              } else {
                final events = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: events.map((event) {
                      return GestureDetector(
                        onTap: () =>  Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EventDetailPage(event: event),
                          ),
                        ),
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 100,
                                maxHeight: 150,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: event.imagePath != null
                                        ? Image.memory(
                                            base64Decode(event.imagePath!),
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 60,
                                            color: Colors.grey.shade300,
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    // Un padding un peu plus grand pour respirer
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          event.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                14, // Une taille légèrement plus grande pour le titre
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1, // Limite à une ligne
                                        ),
                                        const SizedBox(height: 2),
                                        // Espacement entre le titre et la catégorie
                                        Row(
                                          children: [
                                            Icon(
                                              iconMapping[
                                                  event.sportCategory.iconName],
                                              color: Colors.blueAccent,
                                              size: MySizes.iconSm,
                                            ),
                                            const SizedBox(width: 8),
                                            // Espacement entre l'icône et le texte
                                            Text(
                                              event.sportCategory.name,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.access_time,
                                                size: MySizes.iconSm,
                                                color: Colors.blueAccent),
                                            const SizedBox(width: 8),
                                            Text(
                                              event.startTime,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_today,
                                                size: MySizes.iconSm,
                                                color: Colors.blueAccent),
                                            const SizedBox(width: 8),
                                            Text(
                                              event.startDate,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
