import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../data/services/category/category_service.dart';
import '../../../data/services/event/event_service.dart';
import '../../../data/services/profile/user_service.dart';
import '../../../utils/constants/icons.dart';
import '../../events/models/category.dart';
import '../../events/models/event.dart';
import '../models/event_scroll.dart';

class HomeController extends GetxController {
  var userName = ''.obs;
  final selectedCategorie = <String, bool>{}.obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<EventScroll> events = RxList<EventScroll>();
  final box = GetStorage();
  final UserService _userService = UserService();
  final CategoryService categoryService = CategoryService();
  final EventService eventService = EventService();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadEventsByCategories('Skiing');
    int? userId = box.read('user_id');
    if (userId != null) {
      fetchUserName(userId);
    } else {
      print("Aucun ID utilisateur trouvé dans le stockage.");
    }
  }

  // Récupérer le nom de l'utilisateur
  Future<void> fetchUserName(int userId) async {
    try {
      userName.value = await _userService.fetchUserName(userId);
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  // Charger les catégories
  Future<void> loadCategories() async {
    try {
      final List<Category> data = await categoryService.fetchCategories();
      categories.value = data.map((category) {
        final String iconName = category.iconName ?? 'help_outline';
        final String categoryName = category.name;
        final iconData = iconMapping[iconName] ?? Icons.help_outline;
        selectedCategorie[categoryName] = false;

        // Retourner les données formatées
        return {
          'name': categoryName,
          'icon': iconData,
        };
      }).toList();
    } catch (e) {
      print("Error while loading categories: $e");
    }
  }

  // Charger les événements par catégorie
  Future<void> loadEventsByCategories(String category) async {
    try {
      final List<EventScroll> data =
      await categoryService.fetchEventByCategories(category);
      events.value = data; // Met à jour la liste des événements
    } catch (e) {
      print("Error while loading events: $e");
    }
  }

  Future<Event> getEventById(int id) async {
    try {
      Event event= await eventService.getEventById(id);
      print('------------${event.location}---------------------');
      return event;
    } catch (e) {
      print("Error fetching event: $e");
      throw Exception("An error occurred while fetching the event: $e");
    }
  }

  // Basculer entre les catégories sélectionnées
  void toggleCategory(String category) {
    selectedCategorie.updateAll(
            (key, value) => false); // Désélectionner toutes les catégories
    selectedCategorie[category] = true;
    loadEventsByCategories(category); // Sélectionner la catégorie actuelle
  }
}