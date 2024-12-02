import 'package:get/get.dart';

import '../../events/models/category.dart';

class FiltersController extends GetxController {
  RxString selectedDate = 'Any day'.obs;
  RxString selectedTime = 'Any Time'.obs;
  RxString selectedDistance = 'Any Distance'.obs;
  Rx<Category?> selectedCategory = Rx<Category?>(null);

  void updateCategory(Category? category) {
    selectedCategory.value = category;
  }


  void updateDate(String date) {
    selectedDate.value = date;
  }

  void updateTime(String time) {
    selectedTime.value = time;
  }

  void updateDistance(String distance) {
    selectedDistance.value = distance;
  }

  void applyFilters() {
    // Pass selected filters for further use
    print("Filters Applied: "
        "Date: ${selectedDate.value}, "
        "Time: ${selectedTime.value}, "
        "Distance: ${selectedDistance.value}, "
        "Category: ${selectedCategory.value}");
  }
}
