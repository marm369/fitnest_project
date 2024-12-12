import 'dart:convert';

import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../profile/models/user_model.dart';

class ParticipantTile extends StatelessWidget {
  final UserModel user;

  const ParticipantTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  Color getBorderColor(String gender) {
    return gender.toLowerCase().contains("female")
        ? MyColors.babyPink
        : MyColors.accent;
  }

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: dark ? Colors.white : Colors.black,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        color: dark ? Colors.black : Colors.white,
        child: ListTile(
          leading: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: getBorderColor(user.gender),
                width: 3.0,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: user.profilePicture != null
                  ? MemoryImage(base64Decode(user.profilePicture!))
                  : const AssetImage('assets/static-images/default_user.png')
                      as ImageProvider,
              radius: 25,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${user.firstName} ${user.lastName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.white : Colors.black,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: user.interests
                    .map((interest) => Icon(
                          interestMapping[interest] ?? Icons.interests,
                          color: dark ? Colors.white : Colors.black,
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
