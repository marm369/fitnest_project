import 'package:fitnest/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/services/event_service.dart';
import '../../../../data/services/signup_service.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../network_manager.dart';
import '../../screens/signin/signin.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final NetworkManager networkManager = Get.put(NetworkManager());

  final ImagePicker _picker = ImagePicker();
  final pageController = PageController();

  var currentStep = 0.obs;

  var profileImageMessageError = ''.obs;
  var profileImagePath = ''.obs;

  var privacyPolicyMessageError = ''.obs;
  var privacyPolicy = false.obs;

  var frontImagePath = ''.obs;
  var backImagePath = ''.obs;
  var frontImageMessageError = ''.obs;

  var backImageMessageError = ''.obs;

  final selectedInterests = <String, bool>{}.obs;
  final UserService _userService = UserService();

  final List<String> goals = [
    'Make new friends',
    'Track health and fitness goals',
    'Participate in challenges or competitions',
    'Join training or workout sessions',
    'Find and join local sports events',
  ];

  // Utilisation de RxMap pour suivre l'état des objectifs de manière réactive
  final selectedGoals = <String, bool>{}.obs;

  final formKeyStep1 = GlobalKey<FormState>();
  final formKeyStep2 = GlobalKey<FormState>();
  final formKeyStep3 = GlobalKey<FormState>();

  final hidePassword = true.obs;

  // Step1
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Step3
  final birthDate = TextEditingController();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  RxString selectedGender = ''.obs;

  final RxList<Map<String, dynamic>> interests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInterests();
    for (var goal in goals) {
      selectedGoals[goal] = false;
    }
  }

  final SignUpService _signUpService = SignUpService();

  void nextStep() {
    if (currentStep.value == 0) {
      if (this.profileImagePath.value.isEmpty) {
        this.profileImageMessageError.value =
            MyValidator.validateProfileImage(this.profileImagePath.value) ?? '';
      } else {
        this.profileImageMessageError.value = "";
      }
      if (!this.privacyPolicy.value) {
        this.privacyPolicyMessageError.value =
            MyValidator.validateAcceptTerms(this.privacyPolicy.value) ?? '';
      } else {
        this.privacyPolicyMessageError.value = "";
      }

      // Validate Step 1
      if (formKeyStep1.currentState!.validate() &&
          this.privacyPolicy.value &&
          this.profileImagePath.value.isNotEmpty) {
        currentStep.value++;
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        Loaders.warningSnackBar(
          title: 'Validation Error',
          message: 'Please fill in all the fields correctly for Step 1.',
        );
      }
    } else if (currentStep.value == 1) {
      if (this.frontImagePath.value.isEmpty) {
        this.frontImageMessageError.value =
            MyValidator.validateFrontIdImage(this.frontImagePath.value) ?? '';
      } else {
        this.frontImageMessageError.value = "";
      }
      if (this.backImagePath.value.isEmpty) {
        this.backImageMessageError.value =
            MyValidator.validateBackIdImage(this.backImagePath.value) ?? '';
      } else {
        this.backImageMessageError.value = "";
      }
      // Validate Step 2
      if (formKeyStep2.currentState!.validate() &&
          this.frontImagePath.value.isNotEmpty &&
          this.backImagePath.value.isNotEmpty) {
        currentStep.value++;
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        Loaders.warningSnackBar(
          title: 'Validation Error',
          message:
              'Please choose the images for your front and back ID for Step 2.',
        );
      }
    } else if (currentStep.value == 2) {
      // Validate Step 3 or Final Step

      // Continue with Step 3 validation
      if (formKeyStep3.currentState!.validate()) {
        // Get.to(AccountCreatedScreen());
      } else {
        Loaders.warningSnackBar(
          title: 'Validation Error',
          message: 'Please fill in all the fields correctly for Step 3.',
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

  // Date Of Birth and Gender Part

  // Méthode pour sélectionner la date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedDate.value = picked;
      birthDate.text = '${picked.day}/${picked.month}/${picked.year}';
    }
  }

  // Méthode pour mettre à jour le genre sélectionné
  void setGender(String gender) {
    selectedGender.value = gender;
  }

  @override
  void onClose() {
    birthDate.dispose();
    super.onClose();
  }

  // Interests Part

  Future<void> loadInterests() async {
    try {
      // Appel de la méthode du service
      final data = await _userService.fetchInterests();

      // Transformation des données pour correspondre aux variables du contrôleur
      interests.value = data.map((category) {
        final iconName = category['iconName'] as String? ?? 'help_outline';
        final categoryName = category['name'] as String;
        final iconData = iconMapping[iconName] ?? Icons.help_outline;

        // Initialiser la sélection d'intérêts
        selectedInterests[categoryName] = false;

        return {
          'name': categoryName,
          'icon': iconData,
        };
      }).toList();
    } catch (e) {
      print("Erreur lors du chargement des intérêts : $e");
    }
  }

  // Méthode pour basculer l'état de sélection d'un intérêt
  void toggleInterest(String interest) {
    if (selectedInterests.containsKey(interest)) {
      selectedInterests[interest] = !selectedInterests[interest]!;
    }
  }

  List<String> getSelectedInterests() {
    return selectedInterests.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }
  // Goals Part

  // Méthode pour changer l'état de sélection d'un objectif
  void toggleGoal(String goal) {
    selectedGoals[goal] = !selectedGoals[goal]!;
  }

  Future<void> signup() async {
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your information...', MyImages.loadingIllustration);
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        Loaders.errorSnackBar(
          title: 'Connexion échouée',
          message: 'Vérifiez votre connexion Internet.',
        );
        return;
      }
      // Appel du service pour créer un compte
      final token = await _signUpService.createAccount({
        'username': username.text.trim(),
        'password': password.text.trim(),
        'email': email.text.trim(),
      });
      if (token != null) {
        // Préparation des données utilisateur
        final personalInfo = {
          "firstName": firstName.text.trim(),
          "lastName": lastName.text.trim(),
          "email": email.text.trim(),
          "userName": username.text.trim(),
          "password": password.text.trim(),
          "idFace": base64Encode(
              File(frontImagePath.value as String).readAsBytesSync()),
          "idBack": base64Encode(
              File(backImagePath.value as String).readAsBytesSync()),
          "profilePicture": base64Encode(
              File(profileImagePath.value as String).readAsBytesSync()),
          "phoneNumber": int.parse(phoneNumber.text.trim()),
          "birthDate": formatDateForBackend(birthDate.text.trim()),
          "gender": selectedGender.trim(),
          "description": "",
          "interests": getSelectedInterests()
        };
        // Envoi des informations personnelles avec le token
        await _signUpService.savePersonalInfo(personalInfo, token);
/*
        FullScreenLoader.stopLoading();
        Loaders.successSnackBar(
          title: 'Félicitations',
          message: 'Compte créé avec succès!',
        );

 */
        // Get.to(() => VerifyEmailScreen(email: email.text.trim()));
        Get.to(() => SuccessScreen(
              image: MyImages
                  .staticSuccessIllustration, // Remplacez par la vraie valeur de l'image
              title: 'Inscription réussie',
              subTitle: 'Votre compte a été créé avec succès.',
              onPressed: () {
                // Lors du clic sur le bouton, naviguez vers VerifyEmailScreen
                Get.to(() => SignInScreen());
              },
            ));
      }
    } catch (e) {
      FullScreenLoader.stopLoading();
      Loaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  String formatDateForBackend(String inputDate) {
    DateFormat inputFormat = DateFormat('dd/MM/yyyy');
    DateFormat backendFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    DateTime dateTime = inputFormat.parse(inputDate);
    return backendFormat.format(dateTime);
  }
}
