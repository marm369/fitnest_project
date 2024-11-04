import 'package:fitnest/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../data/services/AccountService.dart';
import '../../../../transition_screens/account_created_screen.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  final ImagePicker _picker = ImagePicker();
  final pageController = PageController();

  var currentStep = 0.obs;
  var profileImageError = ''.obs;
  RxBool acceptTerms = false.obs; // Initialisation de l'acceptation des termes
  RxString errorMessage = ''.obs;

  RxString profileImagePath = ''.obs;
  final formKeyStep1 = GlobalKey<FormState>();
  final formKeyStep2 = GlobalKey<FormState>();
  final formKeyStep3 = GlobalKey<FormState>();

  final hidePassword = true.obs;
  final privacyPolicy = false.obs;
  final email = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final firstName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final phoneNumber = TextEditingController();
  final identityFront = Rx<File?>(null);
  final identityBack = Rx<File?>(null);
  final personalPhoto = Rx<File?>(null);
  final birthDate = TextEditingController();
  final gender = TextEditingController();
  final description = TextEditingController();
  final interests = ["HIKE", "FOOTBALL", "WORKOUT"]; // Liste d'intérêts

  final AccountService _accountService = AccountService();

  void nextStep() {
    if (currentStep.value == 0) {
      if (this.profileImagePath.value.isEmpty) {
        this.profileImageError.value =
            MyValidator.validateProfileImage(this.profileImagePath.value)!;
      }
      errorMessage.value =
          MyValidator.validateAcceptTerms(acceptTerms.value) ?? "";
      // Validate Step 1
      if (formKeyStep1.currentState!.validate() && acceptTerms.value) {
        currentStep.value++;
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        if (!acceptTerms.value) {
          errorMessage.value =
              "You must accept the Privacy Policy and Terms of Use.";
        }
        Loaders.warningSnackBar(
          title: 'Erreur de validation',
          message:
              'Veuillez remplir tous les champs obligatoires de l\'étape 1.',
        );
      }
    } else if (currentStep.value == 1) {
      // Validate Step 2
      if (formKeyStep2.currentState!.validate()) {
        currentStep.value++;
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        Loaders.warningSnackBar(
          title: 'Erreur de validation',
          message:
              'Veuillez remplir tous les champs obligatoires de l\'étape 2.',
        );
      }
    } else if (currentStep.value == 2) {
      // Validate Step 3 or Final Step

      // Continue with Step 3 validation
      if (formKeyStep3.currentState!.validate()) {
        Get.to(AccountCreatedScreen());
      } else {
        Loaders.warningSnackBar(
          title: 'Erreur de validation',
          message:
              'Veuillez remplir tous les champs obligatoires de l\'étape 3.',
        );
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> pickImage(Rx<File?> targetFile) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      targetFile.value = File(pickedFile.path);
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      profileImagePath.value = image.path;
    }
  }

  Future<void> signup() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your information...', MyImages.loadingIllustration);
      /*
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
          title: 'Connexion échouée',
          message: 'Vérifiez votre connexion Internet.',
        );
        return;
      }

       */

      // Trace des informations pour le compte utilisateur
      print("Username: ${username.text.trim()}");
      print("Password: ${password.text.trim()}");

      // Appel du service pour créer un compte
      final token = await _accountService.createAccount({
        'username': username.text.trim(),
        'password': password.text.trim(),
      });

      if (token != null) {
        // Trace des informations personnelles
        print("First Name: ${firstName.text.trim()}");
        print("Last Name: ${lastName.text.trim()}");
        print("ID Face Path: ${identityFront.value?.path ?? ''}");
        print("ID Back Path: ${identityBack.value?.path ?? ''}");
        print("Profile Picture Path: ${profileImagePath.value}");
        print("Phone Number: ${phoneNumber.text.trim()}");
        print("Birth Date: ${birthDate.text.trim()}");
        print("Gender: ${gender.text.trim()}");
        print("Description: ${description.text.trim()}");
        print("Interests: ${interests.join(", ")}");

        // Préparation des données utilisateur
        final personalInfo = {
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "idFace": identityFront.value?.path ?? "",
          "idBack": identityBack.value?.path ?? "",
          "profilePicture": profileImagePath.value,
          "phoneNumber": int.parse(phoneNumber.text.trim()),
          "birthDate": "${birthDate.text.trim()}T00:00:00.000+00:00",
          "gender": gender.text.trim(),
          "description": description.text.trim(),
          "interests": interests,
        };

        // Envoi des informations personnelles avec le token
        await _accountService.savePersonalInfo(personalInfo, token);

        FullScreenLoader.stopLoading();
        Loaders.successSnackBar(
          title: 'Félicitations',
          message: 'Compte créé avec succès!',
        );
        Get.to(() => VerifyEmailScreen(email: email.text.trim()));
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }
}
