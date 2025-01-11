import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../events/models/event.dart';
import '../../../events/screens/detail_event.dart';

class EventsSectionWidget extends StatelessWidget {
  final Future<List<Event>> futureEvents;
  final String altTitle;

  const EventsSectionWidget({
    required this.futureEvents,
    required this.altTitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Event>>(
      // Removed Flexible; FutureBuilder shouldn't be wrapped with Flexible.
      future: futureEvents,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Erreur : \${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(altTitle),
          );
        } else {
          final events = snapshot.data!;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: events.map((event) {
                return GestureDetector(
                  onTap: () => Navigator.push(
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
                            padding: const EdgeInsets.all(
                                8.0), // Increased padding for better spacing.
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(height: 4), // Adjusted spacing.
                                Row(
                                  children: [
                                    Icon(
                                      iconMapping[event.sportCategory.iconName],
                                      color: Colors.blueAccent,
                                      size: MySizes.iconSm,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      event.sportCategory.name,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: MySizes.iconSm,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      event.startTime,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: MySizes.iconSm,
                                      color: Colors.blueAccent,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      event.startDate,
                                      style: const TextStyle(fontSize: 12),
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
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }
}
