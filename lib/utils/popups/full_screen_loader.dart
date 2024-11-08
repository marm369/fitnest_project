import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class FullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Container(
          color: HelperFunctions.isDarkMode(Get.context!)
              ? MyColors.dark
              : MyColors.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            // This enables scrolling if content overflows
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centering the content vertically
              children: [
                const SizedBox(height: 250),
                AnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
