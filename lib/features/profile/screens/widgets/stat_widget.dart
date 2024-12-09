import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';

class StatWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const StatWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // Largeur commune définie ici
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: MySizes.borderRadiusSm,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
          vertical: MySizes.xs, horizontal: MySizes.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: MySizes.iconSm,
            color: Colors.blueAccent,
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: MySizes.fontSizeXs,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: MySizes.fontSizeXs,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
