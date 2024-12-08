import 'package:get/get.dart';

class BioController extends GetxController {
  var isExpanded = false.obs;
  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }
}
