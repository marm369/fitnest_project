import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../utils/constants/icons.dart';

class InterestsController extends GetxController {
  final RxList<Map<String, dynamic>> interests = <Map<String, dynamic>>[].obs;
  final selectedInterests = <String, bool>{}
      .obs; // Dictionnaire pour suivre les intérêts sélectionnés

  @override
  void onInit() {
    super.onInit();
    fetchInterests();
  }

  Future<void> fetchInterests() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.237.1:8080/api/categories/getCategories'));
      if (response.statusCode == 200) {
        final data =
            json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        interests.value = data.map((category) {
          final iconName = category['iconName'] as String? ?? 'help_outline';
          final categoryName = category['name'] as String;
          final iconData = iconMapping[iconName] ?? Icons.help_outline;
          selectedInterests[categoryName] = false;
          return {
            'name': categoryName,
            'icon': iconData,
          };
        }).toList();
      } else {
        print('Échec de chargement des catégories : ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur lors du chargement des intérêts : $e");
    }
  }

  // Méthode pour basculer l'état de sélection d'un intérêt
  void toggleInterest(String interest) {
    if (selectedInterests.containsKey(interest)) {
      selectedInterests[interest] =
          !selectedInterests[interest]!; // Inverse l'état de sélection
    }
  }
}
