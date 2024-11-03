import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const MyAppBar(showBackArrow: true, title: Text('Add new Address')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Form(
            child: Column(
              children: [
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.user), labelText: 'Name')),
                const SizedBox(height: MySizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.mobile),
                        labelText: 'Phone Number')),
                const SizedBox(height: MySizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.building_31),
                                labelText: 'Street'))),
                    const SizedBox(width: MySizes.spaceBtwInputFields),
                    Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.code),
                                labelText: 'Pos'))),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.building_31),
                                labelText: 'Street'))),
                    const SizedBox(width: MySizes.spaceBtwInputFields),
                    Expanded(
                        child: TextFormField(
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.code),
                                labelText: 'Pos'))),
                  ],
                ),
                const SizedBox(height: MySizes.spaceBtwInputFields),
                TextFormField(
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Iconsax.global),
                        labelText: 'Country')),
                const SizedBox(height: MySizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Save'),
                  ),
                )
              ],
            ), // Column
          ), // Form
        ), // Padding
      ), // Single Child ScrollView
    ); // Scaffold
  }
}
