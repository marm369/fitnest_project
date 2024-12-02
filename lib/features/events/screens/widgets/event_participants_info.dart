import 'package:flutter/material.dart';

class EventParticipantsInfo extends StatelessWidget {
  final int maxParticipants;
  final int currentNumParticipants;

  EventParticipantsInfo({
    required this.maxParticipants,
    required this.currentNumParticipants,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.people_outline, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text(
              "Max Participants: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "$maxParticipants",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.people,
              color: Colors.blue,
              size: 24,
            ),
            SizedBox(width: 8),
            Text(
              "Current Participants: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              "$currentNumParticipants",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
