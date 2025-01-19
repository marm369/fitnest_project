import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../utils/constants/sizes.dart';
import 'event_participants_info.dart';

class EventInfo extends StatelessWidget {
  final String eventDescription;
  final int maxParticipants;
  final int currentNumParticipants;

  const EventInfo({
    Key? key,
    required this.eventDescription,
    required this.maxParticipants,
    required this.currentNumParticipants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "About Event",
            style: TextStyle(
              fontSize: MySizes.fontSizeLg,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: MySizes.spaceBtwItems),
          ReadMoreText(
            eventDescription,
            style: TextStyle(
              fontSize: MySizes.fontSizeSm,
              fontWeight: FontWeight.w400,
              color: dark ? Colors.white : Colors.black87,
              height: 1.5,
            ),
            trimLines: 3,
            colorClickableText: Colors.blue,
            trimCollapsedText: ' Read More',
            trimExpandedText: ' Read Less',
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: MySizes.sm),
          EventParticipantsInfo(
            maxParticipants: maxParticipants,
            currentNumParticipants: currentNumParticipants,
          ),
        ],
      ),
    );
  }
}
