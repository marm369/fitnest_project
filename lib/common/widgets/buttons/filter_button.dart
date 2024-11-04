import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const FilterButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MySizes.xs),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: MyColors.darkerGrey,
          size: MySizes.iconMd,
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: MyColors.darkerGrey,
            fontSize: MySizes.fontSizeSm,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(
              horizontal: MySizes.md, vertical: MySizes.sm),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MySizes.borderRadiusLg * 2),
            side: const BorderSide(
              color: MyColors.darkerGrey,
            ),
          ),
        ),
      ),
    );
  }
}
