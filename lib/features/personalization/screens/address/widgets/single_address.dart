import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/widgets/custom_shapes/containers/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class SingleAddress extends StatelessWidget {
  const SingleAddress({
    super.key,
    required this.selectedAddress,
  });

  final bool selectedAddress;

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return RoundedContainer(
      width: double.infinity,
      padding: const EdgeInsets.all(MySizes.md),
      showBorder: true,
      backgroundColor: selectedAddress
          ? MyColors.primary.withOpacity(0.5)
          : Colors.transparent,
      borderColor: selectedAddress
          ? Colors.transparent
          : dark
          ? MyColors.darkerGrey
          : MyColors.grey,
      margin: const EdgeInsets.only(bottom: MySizes.spaceBtwItems),
      child: Stack(
        children: [
          Positioned(
            right: 5,
            top: 0,
            child: Icon(
              selectedAddress ? Iconsax.tick_circle5 : null,
              color: selectedAddress
                  ? dark
                  ? MyColors.light
                  : MyColors.dark
                  : null,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ), // Text
              const SizedBox(height: MySizes.sm / 2),
              const Text(' (+123) 456 7890',
                  maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: MySizes.sm / 2),
              const Text('82356 Timmy Coves, South Liana, Maine, 87665, USA',
                  softWrap: true),
            ],
          ) // Column
        ],
      ),
    );
  }
} // Stack
