import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });
  final String image, title, subtitle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MySizes.spaceBtwSections),
      child: Column(
        children: [
          SizedBox(height: MySizes.spaceBtwSections * 4),
          Container(
            width: HelperFunctions.screenWidth() * 0.8,
            height: HelperFunctions.screenWidth() * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover, // Pour que l'image remplisse le cercle
              ),
              border: Border.all(
                color: MyColors.borderSecondary, // Couleur de la bordure
                width: 3.0, // Épaisseur de la bordure
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // Décalage de l'ombre
                ),
              ],
            ),
          ),
          const SizedBox(height: MySizes.spaceBtwSections),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: MySizes.spaceBtwItems),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
