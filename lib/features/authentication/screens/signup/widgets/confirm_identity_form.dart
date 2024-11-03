import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart'; // Importer Iconsax
import 'package:image_picker/image_picker.dart'; // Importer image_picker
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/signup/confirm_identity_controller.dart';
import 'terms_conditions_checkbox.dart';
import 'dart:io'; // Pour gérer les fichiers

class ConfirmIdentityForm extends StatefulWidget {
  const ConfirmIdentityForm({super.key});

  @override
  State<ConfirmIdentityForm> createState() => _ConfirmIdentityFormState();
}

class _ConfirmIdentityFormState extends State<ConfirmIdentityForm> {
  final controller = Get.put(ConfirmIdentityController());
  File? _imageFile; // Stocke l'image sélectionnée

  // Méthode pour sélectionner une image
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Convertir en fichier
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(MySizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                MyTexts.confirmIdentity,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: MySizes.spaceBtwInputFields),

              // Form
              Form(
                key: controller.confirmIdentityKey,
                child: Column(
                  children: [
                    // Input 1: "Scan the front of your ID"
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Scan the front of your ID',
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Input 2: "Scan the back of your ID"
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Scan the back of your ID',
                        prefixIcon: Icon(Iconsax.user_edit),
                      ),
                    ),
                    const SizedBox(height: MySizes.spaceBtwInputFields),

                    // Input 3: "Upload your Image"
                    GestureDetector(
                      onTap:
                          _pickImage, // Appelle la méthode pour ouvrir la galerie
                      child: AbsorbPointer(
                        // Empêche la modification manuelle du champ
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Upload your Image',
                            prefixIcon: Icon(Iconsax.image),
                          ),
                        ),
                      ),
                    ),

                    // Afficher l'image sélectionnée
                    if (_imageFile != null)
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.file(
                          _imageFile!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: MySizes.spaceBtwSections,
              ),

              // Terms & Conditions Checkbox
              const TermsAndConditionsCheckbox(),

              const SizedBox(height: MySizes.spaceBtwSections),

              // Sign up Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Ajoutez l'action à exécuter lors de la création du compte
                    if (controller.confirmIdentityKey.currentState!
                        .validate()) {
                      // Validation du formulaire et action à prendre
                    }
                  },
                  child: const Text(MyTexts.createAccount),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
