// widgets/step_indicator.dart
import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  final int step;
  final String label;
  final bool isActive;

  StepIndicator({
    required this.step,
    required this.label,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12),
        ),
        SizedBox(height: 4),
        Container(
          width: 70,
          height: 8,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
