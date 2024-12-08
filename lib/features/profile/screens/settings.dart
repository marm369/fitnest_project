import 'dart:convert';
import 'dart:io';

import 'package:fitnest/features/profile/screens/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/profile_controller.dart';
import '../controllers/profilepicture_controller.dart';
import 'widgets/update_dateofbirth.dart';
import 'widgets/update_firstname.dart';
import 'widgets/update_lastname.dart';
import 'widgets/update_phonenumber.dart';
import 'widgets/update_username.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());
  final updateProfilePictureController =
      Get.put(UpdateProfilePictureController());

  // Méthode pour rafraîchir les données du profil
  Future<void> _refreshProfile() async {
    await controller.refreshProfile();
  }

  // Méthode pour sélectionner et sauvegarder une image
  Future<void> _pickAndSaveImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      updateProfilePictureController.setImageFile(file);
      await updateProfilePictureController.updateProfilePicture();
      //await controller.refreshProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('Profile'),
        showBackArrow: true,
      ),
      body: Obx(() {
        final userProfile = controller.userProfile.value;
        // Affiche un indicateur de chargement tant que les données ne sont pas chargées
        if (userProfile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: _refreshProfile, // Appelle la méthode de rafraîchissement
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Active le défilement même si le contenu est insuffisant
            child: Padding(
              padding: const EdgeInsets.all(MySizes.defaultSpace),
              child: Column(
                children: [
                  // Affichage de l'image de profil
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Builder(
                          builder: (context) {
                            try {
                              // Décodage de l'image base64
                              final imageBytes = base64Decode(
                                  userProfile.profilePicture ?? '');
                              return CircleAvatar(
                                radius: 60,
                                backgroundImage: MemoryImage(imageBytes),
                              );
                            } catch (e) {
                              // Affiche une image par défaut en cas d'erreur
                              return const CircleAvatar(
                                radius: 40,
                                backgroundImage: AssetImage(
                                    'assets/images/default_user.png'),
                              );
                            }
                          },
                        ),
                        TextButton(
                          onPressed:
                              _pickAndSaveImage, // Appelle directement la méthode
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            foregroundColor: Colors.blue, // Couleur du texte
                            textStyle: const TextStyle(
                              fontSize: 14, // Taille du texte
                              fontWeight: FontWeight
                                  .w500, // Poids du texte pour une meilleure lisibilité
                            ),
                          ),
                          child: const Text('Change Profile Picture'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  const Divider(),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  // Informations de profil
                  SectionHeading(
                      title: 'Profile Information', showActionButton: false),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  ProfileMenu(
                    title: 'Username',
                    value: userProfile.userName,
                    onPressed: () => Get.to(() => UpdateUserName()),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  ProfileMenu(
                      title: 'Email',
                      value: userProfile.email,
                      onPressed: () => {}),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  const Divider(),
                  const SizedBox(height: MySizes.spaceBtwItems),

                  // Informations personnelles
                  const SectionHeading(
                      title: 'Personal Information', showActionButton: false),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  ProfileMenu(
                    title: 'First Name',
                    value: userProfile.firstName,
                    onPressed: () => Get.to(() => const UpdateFirstName()),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  ProfileMenu(
                    title: 'Last Name',
                    value: userProfile.lastName,
                    onPressed: () => Get.to(() => const UpdateLastName()),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  ProfileMenu(
                    title: 'Phone Number',
                    value: userProfile.phoneNumber.toString(),
                    onPressed: () => Get.to(() => const UpdatePhoneNumber()),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  ProfileMenu(
                    title: 'Date of Birth',
                    value:
                        DateFormat('dd-MM-yyyy').format(userProfile.dateBirth),
                    onPressed: () => Get.to(() => const UpdateDateOfBirth()),
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems / 2),
                  ProfileMenu(
                    title: 'Gender',
                    value: userProfile.gender,
                    onPressed: () => {},
                  ),
                  const SizedBox(height: MySizes.spaceBtwItems),
                  const Divider(),
                  const SizedBox(height: MySizes.spaceBtwItems),

                  // Bouton pour fermer le compte
                  Center(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey, // Couleur principale
                        shape: StadiumBorder(), // Boutons arrondis simples
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white, // Couleur du texte
                          fontSize: 14, // Taille du texte
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
