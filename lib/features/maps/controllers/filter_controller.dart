import 'dart:convert';

import 'package:dynamic_multi_step_form/dynamic_multi_step_form.dart';
import 'package:fitnest/data/services/event/event_service.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../data/services/map/current_position.dart';
import '../../events/models/category.dart';
import '../../events/models/event.dart';
import 'package:http/http.dart' as http;

class FiltersController extends GetxController {
  RxString selectedDate = ''.obs;
  RxString selectedTime = ''.obs;
  RxString selectedDistance = ''.obs;
  Rx<Category?> selectedCategory = Rx<Category?>(null);
  RxList<Event> nearbyEvents = <Event>[].obs;
  final CurrentPosition currentPositionService = CurrentPosition();
  final EventService eventService = EventService();
  void updateCategory(Category? category) {
    selectedCategory.value = category;
  }

  void updateDate(String date) {
    selectedDate.value = date;
  }

  void updateTime(String time) {
    selectedTime.value = time;
  }

  void updateDistance(String distance) async {
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
