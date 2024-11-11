import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String eventImage;
  final String title;
  final String date;
  final String profileImage;
  final String organizer;

  const EventCard({
    Key? key,
    required this.eventImage,
    required this.title,
    required this.date,
    required this.profileImage,
    required this.organizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              eventImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Divider(color: Colors.grey),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileImage),
                      radius: 16,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        organizer,
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.map,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                      onPressed: () {
                        // Action pour l'icône de carte
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Open Map for $title')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
