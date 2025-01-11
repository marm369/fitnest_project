import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/profile_controller.dart';

class InterestsWidget extends StatelessWidget {
  final int userId;

  InterestsWidget({required this.userId});

  final ProfileController profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: profileController.getUserInterests(
          userId), // Appel de la fonction pour récupérer les intérêts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
          ); // Affichage d'un loader pendant le chargement
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Oops, something went wrong: ${snapshot.error}',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          ); // Affichage d'un message d'erreur
        } else if (snapshot.hasData) {
          List<String> interests = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MySizes.xs),
                interests.isEmpty
                    ? Center(
                        child: Text(
                          'No interests found',
                          style:
                              TextStyle(fontSize: 18, color: Colors.grey[600]),
                        ),
                      )
                    : Wrap(
                        spacing: 5.0, // Espacement horizontal entre les chips
                        runSpacing: 5.0, // Espacement vertical entre les chips
                        children: interests.map((interest) {
                          return Chip(
                            label: Text(
                              interest,
                              style: TextStyle(
                                  fontSize: MySizes.fontSizeSm,
                                  color: MyColors.primary),
                            ),
                            backgroundColor: MyColors.white,
                            padding:
                                EdgeInsets.symmetric(horizontal: MySizes.xs),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                color:
                                    MyColors.primary, // Couleur de la bordure
                                width: 2.0, // Largeur de la bordure
                              ),
                            ),
                            elevation: 4,
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        } else {
          return Center(child: Text('No interests found'));
        }
      },
    );
  }
}
