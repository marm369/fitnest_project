import 'package:get/get.dart';

class FiltersController extends GetxController {
  // Filter values
  RxString? selectedDate = 'Any day'.obs;
  RxString? selectedTime = 'Any Time'.obs;
  RxString? selectedDistance = 'Any Distance'.obs;
  RxString? selectedCategory = ''.obs;

  // Function to update selected category
  void updateCategory(String? category) {
    selectedCategory?.value = category!;
  }

  // Function to update selected date
  void updateDate(String? date) {
    selectedDate?.value = date!;
  }

  // Function to update selected time
  void updateTime(String? time) {
    selectedTime?.value = time!;
  }

  // Function to update selected distance
  void updateDistance(String? distance) {
    selectedDistance?.value = distance!;
  }

  // Function to apply filters
  void applyFilters() {
    // This could be a callback to update the parent widget
    // with the selected filters.
  }
}
