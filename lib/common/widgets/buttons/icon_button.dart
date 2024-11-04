import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';

class IconButtonW extends StatelessWidget {
  final Color iconColor; // Couleur de l'icône
  final IconData icon; // Icône
  final VoidCallback onPressed; // Fonction onPressed

  const IconButtonW({
    Key? key,
    required this.iconColor,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: MyColors.darkerGrey,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(icon,
              color: iconColor), // Utilisation de la couleur et de l'icône
          onPressed: onPressed,
        ),
      ),
    );
  }
}
