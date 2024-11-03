import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SearchContainer extends StatelessWidget {
  const SearchContainer({
    super.key,
    required this.text,
    this.icon = Iconsax.search_normal,
    this.showBackground = true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: MySizes.defaultSpace),
  });
  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Padding(
      padding: padding,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            width: MyDeviceUtils.getScreenWidth(context),
            padding: const EdgeInsets.all(MySizes.md),
            decoration: BoxDecoration(
                color: showBackground
                    ? dark
                        ? MyColors.dark
                        : MyColors.light
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(MySizes.cardRadiusLg),
                border: showBorder ? Border.all(color: MyColors.grey) : null),
            child: Row(
              children: [
                Icon(icon, color: MyColors.darkerGrey),
                const SizedBox(width: MySizes.spaceBtwItems),
                Text(text, style: Theme.of(context).textTheme.bodySmall),
              ],
            )),
      ),
    );
  }
}
