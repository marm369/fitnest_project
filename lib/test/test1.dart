import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/events/controllers/category_controller.dart'; // Assurez-vous que le chemin d'importation est correct
import '../../../features/events/models/category.dart'; // Assurez-vous que le chemin d'importation est correct

class CategoryListScreen extends StatelessWidget {
  // Instancier le contrôleur
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Catégories"),
      ),
      body: Obx(() {
        // Observer si les catégories sont encore en cours de chargement
        if (categoryController.isLoading.value) {
          return Center(
              child:
                  CircularProgressIndicator()); // Afficher un indicateur de chargement si c'est en cours
        } else if (categoryController.categories.isEmpty) {
          // Si aucune catégorie n'est récupérée après le chargement
          return Center(child: Text("Aucune catégorie disponible"));
        } else {
          return ListView.builder(
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];
              return ListTile(
                title: Text(category.name ??
                    "Nom inconnu"), // Afficher le nom de la catégorie
                subtitle:
                    Text("ID: ${category.id}"), // Afficher l'ID de la catégorie
                onTap: () {
                  // Vous pouvez définir un comportement pour l'élément tapé, par exemple pour la sélection
                  categoryController.setSelectedCategory(category);
                },
              );
            },
          );
        }
      }),
    );
  }
}
