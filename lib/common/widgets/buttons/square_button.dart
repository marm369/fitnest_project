import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/constants/sizes.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final String? image; // Image optionnelle
  final String? Function(String?)? validator; // Fonction de validation

  SquareButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    this.image,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    // Applique la validation et stocke le message d'erreur, s'il y en a un.
    final String? errorText = validator != null ? validator!(image) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity, // Prend toute la largeur possible
          height: 150,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF8F8F8), // Fond couleur blanc cassé
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:
                  EdgeInsets.zero, // Pas de padding pour utiliser tout l'espace
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(image!),
                      fit: BoxFit.cover, // Remplit tout l'espace du bouton
                    ),
                  ),
                if (image == null)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: Colors.blue,
                        size: 20,
                      ),
                      SizedBox(height: MySizes.sm),
                      Text(
                        text,
                        style: TextStyle(color: Colors.black), // Texte en noir
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        if (errorText != null) // Affiche le message d'erreur s'il existe
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              errorText,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
