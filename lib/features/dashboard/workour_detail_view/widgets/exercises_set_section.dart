import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import 'exercises_row.dart';

class ExercisesSetSection extends StatelessWidget {
  final Map sObj;
  final Function(Map obj) onPressed;
  const ExercisesSetSection(
      {Key? key, required this.sObj, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var exercisesArr = sObj["set"] as List? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          sObj["name"].toString(),
          style: TextStyle(
              color: MyColors.black, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: exercisesArr.length,
            itemBuilder: (context, index) {
              var eObj = exercisesArr[index] as Map? ?? {};
              return ExercisesRow(
                eObj: eObj,
                onPressed: () {
                  onPressed(eObj);
                },
              );
            }),
      ],
    );
  }
}
