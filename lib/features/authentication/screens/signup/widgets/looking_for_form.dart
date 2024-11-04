import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/looking_for_controller.dart';

class LookingForForm extends StatelessWidget {
  final LookingForController controller = Get.put(LookingForController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          MyTexts.lookingFor,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: MySizes.spaceBtwItems),
        Obx(
          () => Wrap(
            spacing: MySizes.md,
            runSpacing: MySizes.md,
            children: List.generate(controller.goals.length, (index) {
              final goal = controller.goals[index];
              final isSelected = controller.selectedGoals[goal] ?? false;

              return GestureDetector(
                onTap: () => controller.toggleGoal(goal),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MySizes.lg / 2, vertical: MySizes.sm),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[50] : Colors.white,
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.grey[400]!,
                    ),
                    borderRadius: BorderRadius.circular(MySizes.borderRadiusMd),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.circle_outlined,
                        color: isSelected ? Colors.blue : Colors.grey[600],
                      ),
                      SizedBox(width: MySizes.sm),
                      Text(
                        goal,
                        style: TextStyle(
                          fontSize: MySizes.fontSizeSm,
                          color: isSelected ? Colors.blue[800] : Colors.black87,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
