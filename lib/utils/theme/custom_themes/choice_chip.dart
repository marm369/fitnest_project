import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../common/widgets/custom_shapes/containers/circular_container.dart';
import '../../constants/colors.dart';

/// -- Most of the Styling is already defined in the Utils -> Themes -> Chip Theme.dart
class MyChoiceChip extends StatelessWidget {
  const MyChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });
  final String text;
  final bool selected;
  final void Function(bool)? onSelected;
  @override
  Widget build(BuildContext context) {
    final isColor = HelperFunctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: Colors.transparent,
      ),
      child: ChoiceChip(
        label: isColor ? const SizedBox() : Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? MyColors.white : null),
        avatar: isColor
            ? CircularContainer(
                width: 50,
                height: 50,
                backgroundcolor: HelperFunctions.getColor(text)!)
            : null,
        labelPadding: isColor ? const EdgeInsets.all(0) : null,
        // Make icon in the center
        padding: isColor ? const EdgeInsets.all(0) : null,
        shape: isColor ? const CircleBorder() : null,
        backgroundColor: isColor ? HelperFunctions.getColor(text)! : null,
      ),
    ); // ChoiceChip
  }
}
