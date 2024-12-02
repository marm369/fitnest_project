import 'package:flutter/material.dart';
import 'dart:io';
import '../../../utils/constants/sizes.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final String? image;
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
          width: double.infinity,
          height: 150,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF8F8F8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.zero,
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(image!),
                      fit: BoxFit.cover,
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
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
