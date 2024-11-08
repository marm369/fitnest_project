import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/change_username_service.dart';
import '../../../utils/popups/full_screen_loader.dart';
import '../../../utils/popups/loaders.dart';

class UpdateUsernameController extends GetxController {
  static UpdateUsernameController get instance => Get.find();

  final formKeyUsername = GlobalKey<FormState>(); // Formulaire de validation
  final username = TextEditingController(); // Contrôleur du champ "username"

  final ChangeUsernameService _changeUsernameService = ChangeUsernameService();

  // Fonction pour changer le nom d'utilisateur
  Future<void> changeUsername() async {
    if (formKeyUsername.currentState?.validate() ?? false) {
      // Validation du formulaire
      try {
        // Appel du service pour changer le nom d'utilisateur
        final token = await _changeUsernameService.changeUsername({
          'username': username.text.trim(),
        });

        // Si tout se passe bien, stop le loader et montrer une notification de succès
        FullScreenLoader.stopLoading();
        Loaders.successSnackBar(
            title: 'Succès', message: 'Nom d\'utilisateur changé avec succès');
      } catch (e) {
        FullScreenLoader.stopLoading(); // Arrêt du loader en cas d'erreur
        Loaders.errorSnackBar(
            title: 'Erreur', message: e.toString()); // Affichage de l'erreur
      }
    } else {
      Loaders.errorSnackBar(
          title: 'Erreur',
          message: 'Veuillez entrer un nom d\'utilisateur valide.');
    }
  }
}
