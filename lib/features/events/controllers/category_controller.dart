import 'package:get/get.dart';
import '../../../data/services/category/category_service.dart';
import '../../../utils/popups/loaders.dart';
import '../models/category.dart';

class CategoryController extends GetxController {
  final CategoryService categoryService = CategoryService();

  // Variable de chargement
  var isLoading = true.obs; // Par défaut, l'état est de chargement
  var categories = <Category>[].obs;
  var selectedCategory = Rxn<Category>();
  final requiresRoute = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      // Définir l'état de chargement à true avant de récupérer les données
      isLoading.value = true;

      final fetchedCategories = await categoryService.fetchCategories();
      categories.value = fetchedCategories;
      // Assurez-vous qu'une catégorie soit sélectionnée par défaut
      if (categories.isNotEmpty) {
        selectedCategory.value =
            categories.first; // Sélectionner la première catégorie par défaut
      }
      // Une fois les données récupérées, on définit l'état de chargement à false
      isLoading.value = false;
    } catch (e) {
      // Gérer l'erreur de chargement
      isLoading.value = false;
      Loaders.errorSnackBar(
          title: "Error", message: "Unable to load categories");
    }
  }

  // Mettre à jour la catégorie sélectionnée
  void setSelectedCategory(Category category) {
    selectedCategory.value = category;
    requiresRoute.value = selectedCategory.value!.requiresRoute;
  }
}
