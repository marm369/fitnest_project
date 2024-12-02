import 'dart:convert';
import 'dart:typed_data';

import 'package:fitnest/features/profile/screens/widgets/profile_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/images/circular_image.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../controllers/profile_controller.dart';
import 'widgets/update_dateofbirth.dart';
import 'widgets/update_email.dart';
import 'widgets/update_firstname.dart';
import 'widgets/update_lastname.dart';
import 'widgets/update_phonenumber.dart';
import 'widgets/update_username.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    final userProfile = controller.userProfile.value!;
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Profile'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // Décodage de l'image base64 avant de l'utiliser
                    Builder(
                      builder: (context) {
                        try {
                          // Décodage de l'image base64
                          final imageBytes =
                              base64Decode(userProfile.profilePicture ?? '');

                          return CircleAvatar(
                            radius:
                                40, // Ajustez la taille du cercle comme vous le souhaitez
                            backgroundImage: MemoryImage(
                                imageBytes), // Utilisez MemoryImage pour afficher l'image
                          );
                        } catch (e) {
                          // Si l'image ne peut pas être décodée, afficher une image par défaut
                          return CircleAvatar(
                            radius: 40,
                            backgroundImage:
                                AssetImage(MyImages.defaultImageProfile),
                          );
                        }
                      },
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Change Profile Picture'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),
              SectionHeading(
                  title: 'Profile Information ', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwItems),
              ProfileMenu(
                  title: 'Username',
                  value: userProfile.userName,
                  onPressed: () => Get.to(() => const UpdateUsername())),

              ProfileMenu(
                  title: 'Email',
                  value: userProfile.email,
                  onPressed: () => Get.to(() => const UpdateEmail())),
              const SizedBox(height: MySizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),

              /// Heading Personal Info
              const SectionHeading(
                  title: 'Personal Information', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwItems),
              ProfileMenu(
                  title: 'First Name',
                  value: userProfile.firstName,
                  onPressed: () => Get.to(() => const UpdateFirstName())),
              ProfileMenu(
                  title: 'Last Name',
                  value: userProfile.lastName,
                  onPressed: () => Get.to(() => const UpdateLastName())),
              ProfileMenu(
                  title: 'Phone Number',
                  value: userProfile.phoneNumber.toString(),
                  onPressed: () => Get.to(() => const UpdatePhoneNumber())),
              ProfileMenu(
                  title: 'Date of Birth',
                  value: userProfile.dateBirth.toString(),
                  onPressed: () => Get.to(() => const UpdateDateOfBirth())),
              ProfileMenu(title: 'Gender', value: 'Female', onPressed: () {}),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Close Account',
                      style: TextStyle(color: Colors.red)),
                ), // TextButton
              ), // Center
            ],
          ),
        ),
      ),
    );
  }
}
