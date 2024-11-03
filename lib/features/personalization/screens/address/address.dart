import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import 'add_new_address.dart';
import 'widgets/single_address.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.primary,
        onPressed: () => Get.to(() => const AddNewAddressScreen()),
        child: const Icon(Iconsax.add, color: MyColors.white),
      ), // FloatingActionButton
      appBar: MyAppBar(
        showBackArrow: true,
        title:
        Text('Addresses', style: Theme.of(context).textTheme.headlineSmall),
      ), // TAppBar
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(MySizes.defaultSpace),
          child: Column(children: [
            SingleAddress(selectedAddress: false),
            SingleAddress(selectedAddress: true),
          ]), // Column
        ), // Padding
      ), // SingleChild ScrollView
    ); // Scaffold
  }
}
