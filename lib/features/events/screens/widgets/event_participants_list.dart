import 'package:fitnest/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../profile/models/user_model.dart';
import 'participants_tile.dart';

class ParticipantsList extends StatelessWidget {
  final Future<List<UserModel>> participants;

  ParticipantsList({
    Key? key,
    required this.participants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
      future: participants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur : ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun participant trouvé.'));
        } else {
          final participants = snapshot.data!;
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MySizes.xs, vertical: 0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.groups, // Choisissez l'icône que vous souhaitez
                          color: Colors.blueAccent,
                          size: MySizes.iconMd,
                        ),
                        SizedBox(
                            width:
                                MySizes.sm), // Espace entre l'icône et le texte
                        Text(
                          "Participants list:",
                          style: TextStyle(
                            fontSize: MySizes.fontSizeMd,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: participants.length,
                  itemBuilder: (context, index) {
                    final user = participants[index];
                    return ParticipantTile(user: user);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
