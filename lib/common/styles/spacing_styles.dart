import 'package:flutter/material.dart';
import 'package:fitnest/utils/constants/sizes.dart';

class SpacingStyle {
  static const EdgeInsetsGeometry paddingWithAppBarHeight = EdgeInsets.only(
    top: MySizes.appBarHeight,
    left: MySizes.defaultSpace,
    bottom: MySizes.defaultSpace,
    right: MySizes.defaultSpace,
  );
}
