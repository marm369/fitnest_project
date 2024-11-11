import 'package:flutter/material.dart';

class TabItem extends StatelessWidget {
  final String text;
  final Icon icon;

  const TabItem({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(
          height: 5,
        ),
        Text(
          text,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
