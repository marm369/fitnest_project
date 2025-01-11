import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class SportCategoryChip extends StatelessWidget {
  final String categoryName;
  final IconData categoryIcon;

  const SportCategoryChip({
    required this.categoryName,
    required this.categoryIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Access the theme's brightness for light/dark mode
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent, // Transparent Material background
      child: Chip(
        backgroundColor: isDarkTheme
            ? Colors.grey.shade800 // Dark background for dark theme
            : Colors.grey.shade200, // Light background for light theme
        padding: const EdgeInsets.symmetric(
            horizontal: 8, vertical: 4), // Inner padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Rounded edges
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              categoryIcon, // Use the icon provided
              size: 18, // Icon size
              color: isDarkTheme
                  ? MyColors.light
                  : MyColors.dark, // Adapt icon color to theme
            ),
            const SizedBox(width: 6), // Space between icon and text
            Text(
              categoryName, // Display the category name
              style: TextStyle(
                fontSize: 14, // Text size
                fontWeight: FontWeight.w600,
                color: isDarkTheme
                    ? MyColors.light
                    : MyColors.dark, // Adapt text color to theme
              ),
            ),
          ],
        ),
      ),
    );
  }
}
