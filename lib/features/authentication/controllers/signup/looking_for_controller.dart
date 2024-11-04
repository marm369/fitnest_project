import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LookingForController extends GetxController {
  final List<String> goals = [
    'Make new friends',
    'Track health and fitness goals',
    'Participate in challenges or competitions',
    'Join training or workout sessions',
    'Find and join local sports events',
  ];

  // Utilisation de RxMap pour suivre l'état des objectifs de manière réactive
  final selectedGoals = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialisation de chaque objectif comme non sélectionné (false)
    for (var goal in goals) {
      selectedGoals[goal] = false;
    }
  }

  // Méthode pour changer l'état de sélection d'un objectif
  void toggleGoal(String goal) {
    selectedGoals[goal] = !selectedGoals[goal]!;
  }
}
