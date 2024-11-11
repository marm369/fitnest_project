import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/validators/validation.dart';
import '../../controllers/controller_username.dart';

class UpdateUsername extends StatelessWidget {
  const UpdateUsername({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(UsernameController()); // Utilisation du contrôleur

    return Scaffold(
      // Custom Appbar
      appBar: MyAppBar(
        showBackArrow: true,
        title: Text('Change Username',
            style: Theme.of(context).textTheme.headlineSmall),
      ), // TAppBar
      body: Padding(
        padding: const EdgeInsets.all(MySizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headings
            Text(
              'For the best experience, try selecting a username that’s unique and easy for others to remember.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            const SizedBox(height: MySizes.spaceBtwSections),

            // Formulaire pour entrer le nom d'utilisateur
            Form(
              key: controller.formKeyUsername,
              child: Column(
                children: [
                  TextFormField(
                    controller:
                        controller.username, // Liaison avec le contrôleur
                    validator: (value) => MyValidator.validateEmptyText(
                        'Username', value), // Validation personnalisée
                    decoration: const InputDecoration(
                        labelText: MyTexts.username,
                        prefixIcon: Icon(Iconsax.user)),
                  ),
                ],
              ),
            ), // Formulaire pour le nom d'utilisateur
            const SizedBox(height: MySizes.spaceBtwSections),

            // Bouton pour sauvegarder le nouveau nom d'utilisateur
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller
                      .changeUsername(); // Appel de la méthode de changement de nom d'utilisateur
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
