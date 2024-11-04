import 'package:flutter/material.dart';

import '../../../../utils/constants/image_strings.dart';

class StoryUploadCard extends StatelessWidget {
  const StoryUploadCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          height: 73,
          width: 73,
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              image: DecorationImage(
                  image: AssetImage(MyImages.kUser1), fit: BoxFit.cover)),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration:
                const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: const Icon(Icons.add, color: Colors.white, size: 15),
          ),
        )
      ],
    );
  }
}
