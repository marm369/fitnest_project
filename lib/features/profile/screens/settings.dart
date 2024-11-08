import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/images/circular_image.dart';
import '../../../common/widgets/texts/section_heading.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../personalization/screens/profile/widgets/profile_menu.dart';
import 'widgets/update_dateofbirth.dart';
import 'widgets/update_email.dart';
import 'widgets/update_firstname.dart';
import 'widgets/update_lastname.dart';
import 'widgets/update_phonenumber.dart';
import 'widgets/update_username.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  title: 'Profile Information ', showActionButton: false),
              const SizedBox(height: MySizes.spaceBtwItems),
              ProfileMenu(
                  title: 'Username',
                  value: "minou",
                  //value: controller.user.value.fullName,
                  onPressed: () => Get.to(() => const UpdateUsername())),

              ProfileMenu(
                  title: 'Email',
                  value: "minouarim@gmail.com",
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
                  value: "maryem",
                  onPressed: () => Get.to(() => const UpdateFirstName())),
              ProfileMenu(
                  title: 'Last Name',
                  value: "minouari",
                  onPressed: () => Get.to(() => const UpdateLastName())),
              ProfileMenu(
                  title: 'Phone Number',
                  value: "0700467496",
                  onPressed: () => Get.to(() => const UpdatePhoneNumber())),
              ProfileMenu(
                  title: 'Date of Birth',
                  value: '10 Fév, 2003',
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
