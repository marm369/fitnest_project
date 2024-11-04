import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ConfirmIdentityController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  // Variables observables qui contiennent le chemin des images sélectionnées
  RxString frontImagePath = ''.obs;
  RxString backImagePath = ''.obs;
  RxString profileImagePath =
      ''.obs; // Ajout de la variable pour l'image de profil

  // Méthode pour sélectionner l'image de face
  Future<void> pickFrontImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      frontImagePath.value = image.path;
    }
  }

  // Méthode pour sélectionner l'image de dos
  Future<void> pickBackImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      backImagePath.value = image.path;
    }
  }
}
