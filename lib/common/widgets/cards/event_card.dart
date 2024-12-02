import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySizes.sm),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(MySizes.sm)),
            child: Image.network(
              eventImage,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover, // ensures the image maintains its aspect ratio
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: MySizes.fontSizeMd,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis, // handles overflow text
                ),
                SizedBox(height: MySizes.xs / 2),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: MySizes.fontSizeXs,
                    color: Colors.grey[600],
                  ),
                ),
                Divider(color: Colors.grey),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(profileImage),
                      radius: MySizes.md,
                    ),
                    SizedBox(width: MySizes.sm),
                    Expanded(
                      child: Text(
                        organizer,
                        style: TextStyle(
                            fontSize: MySizes.fontSizeSm,
                            color: Colors.black87),
                        overflow:
                            TextOverflow.ellipsis, // handles overflow text
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.map,
                        color: Colors.redAccent,
                        size: MySizes.iconMd,
                      ),
                      onPressed: () {
                        // Action for the map icon
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
