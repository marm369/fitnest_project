import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/images/circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/user_controller.dart';
import 'widgets/change_name.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: MyAppBar(
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
                    CircularImage(
                        image: MyImages.google, width: 80, height: 80),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Change Profile Picture')),
                  ],
                ),
              ),
              const SizedBox(height: MySizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),
              SectionHeading(
                  title: 'Profile Informtion ', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwItems),
              ProfileMenu(
                  title: 'Name',
                  value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const ChangeName())),

              ProfileMenu(
                  title: 'Username',
                  value: controller.user.value.username,
                  onPressed: () {}),
              const SizedBox(height: MySizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),

              /// Heading Personal Info
              const SectionHeading(
                  title: 'Personal Information', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwItems),
              ProfileMenu(
                  title: 'User ID',
                  value: controller.user.value.id,
                  onPressed: () {}),
              ProfileMenu(
                  title: 'E-mail',
                  value: controller.user.value.email,
                  onPressed: () {}),
              ProfileMenu(
                  title: 'Phone Number',
                  value: controller.user.value.phoneNumber,
                  onPressed: () {}),
              ProfileMenu(title: 'Gender', value: 'Male', onPressed: () {}),
              ProfileMenu(
                  title: 'Date of Birth',
                  value: '10 Oct, 1994',
                  onPressed: () {}),
              const Divider(),
              const SizedBox(height: MySizes.spaceBtwItems),
              Center(
                child: TextButton(
                  onPressed: () => controller.deleteAccountWarningPopup(),
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
