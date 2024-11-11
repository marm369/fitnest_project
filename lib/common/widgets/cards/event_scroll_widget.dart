import 'package:flutter/material.dart';
import 'event_card.dart';

class EventScrollWidget extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'eventImage': 'https://via.placeholder.com/300x200',
      'title': 'Music Festival',
      'date': 'Dec 15, 2024',
      'profileImage': 'https://via.placeholder.com/50',
      'organizer': 'John Doe',
    },
    {
      'eventImage': 'https://via.placeholder.com/300x200',
      'title': 'Art Exhibition',
      'date': 'Nov 20, 2024',
      'profileImage': 'https://via.placeholder.com/50',
      'organizer': 'Alice Smith',
    },
    {
      'eventImage': 'https://via.placeholder.com/300x200',
      'title': 'Tech Conference',
      'date': 'Jan 10, 2025',
      'profileImage': 'https://via.placeholder.com/50',
      'organizer': 'Mike Johnson',
    },
    {
      'eventImage': 'https://via.placeholder.com/300x200',
      'title': 'Food Fair',
      'date': 'Dec 30, 2024',
      'profileImage': 'https://via.placeholder.com/50',
      'organizer': 'Emma Brown',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: EventCard(
            eventImage: event['eventImage']!,
            title: event['title']!,
            date: event['date']!,
            profileImage: event['profileImage']!,
            organizer: event['organizer']!,
          ),
        );
      },
    );
  }
}
