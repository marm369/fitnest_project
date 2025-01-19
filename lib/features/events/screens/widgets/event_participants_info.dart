import 'package:fitnest/utils/constants/sizes.dart';
import 'package:fitnest/utils/helpers/helper_functions.dart';
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
    final dark = HelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.people_outline, color: Colors.green, size: 24),
            SizedBox(width: MySizes.sm),
            Text(
              "Max Participants: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "$maxParticipants",
              style: TextStyle(
                fontSize: 16,
                color: dark ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
        SizedBox(height: MySizes.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.people,
              color: Colors.blue,
              size: 24,
            ),
            SizedBox(width: MySizes.sm),
            Text(
              "Current Participants: ",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              "$currentNumParticipants",
              style: TextStyle(
                fontSize: 16,
                color: dark ? Colors.white : Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
