import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class PrimaryHeaderContainer extends StatelessWidget {
  const PrimaryHeaderContainer({
    super.key,
    required this.child,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return CurvedEdgeWidget(
      child: Container(
        color: MyColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
              top: -200,
              right: -50,
              left: 50,
              child: CircularContainer(
                  backgroundcolor: MyColors.textWhite.withOpacity(0.1)),
            ),
            Positioned(
              top: 10,
              right: -200,
              child: CircularContainer(
                  backgroundcolor: MyColors.textWhite.withOpacity(0.1)),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
