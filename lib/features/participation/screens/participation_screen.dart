import 'package:fitnest/features/participation/screens/requests_page.dart';
import 'package:fitnest/features/participation/screens/responses_page.dart';
import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../controllers/participation_controller.dart';

class ParticipationScreen extends StatelessWidget {
  final ParticipationController controller = Get.put(ParticipationController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participations'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMenuButton('Requests', controller),
              const SizedBox(width: 20),
              _buildMenuButton('Responses', controller),
            ],
          ),
          const SizedBox(height: 20),
          // Contenu dynamique basé sur l'état
          Expanded(
            child: Obx(() {
              return controller.selectedMenu.value == 'Requests'
                  ? RequestsPage()
                  : ResponsesPage();
            }),
          ),
        ],
      ),
    );
  }

  // Bouton de menu
  Widget _buildMenuButton(String menu, ParticipationController controller) {
    return Obx(() {
      final isSelected = controller.selectedMenu.value ==
          menu; // Vérifier si l'élément est sélectionné
      return GestureDetector(
        onTap: () {
          controller
              .changeMenu(menu); // Appeler la méthode pour changer le menu
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          // Durée de l'animation
          curve: Curves.easeInOut,
          // Courbe pour un effet doux
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? MyColors.primary
                : Colors.transparent, // Fond coloré si sélectionné
            borderRadius: BorderRadius.circular(25), // Coins arrondis
          ),
          child: Text(
            menu,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : Colors.grey[600], // Couleur du texte selon l'état
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    });
  }
}
