import 'dart:convert';

import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../../data/services/category/category_service.dart';
import '../../../../data/services/authentication/id_check_service.dart';
import '../../../../data/services/authentication/signup_service.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/validators/validation.dart';
import '../../../events/models/category.dart';
import '../../../network_manager.dart';
import '../../screens/signup/verify_email.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final NetworkManager networkManager = Get.put(NetworkManager());

  final ImagePicker _picker = ImagePicker();
  final pageController = PageController();
  final box = GetStorage();
  var currentStep = 0.obs;

  var profileImageMessageError = ''.obs;
  RxString profileImagePath = ''.obs;

  var privacyPolicyMessageError = ''.obs;
  var privacyPolicy = false.obs;

  RxString frontImagePath = ''.obs;
  RxString backImagePath = ''.obs;
  var frontImageMessageError = ''.obs;

  var backImageMessageError = ''.obs;

  final selectedInterests = <String, bool>{}.obs;
  final CategoryService categoryService = CategoryService();

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

  Map<String, dynamic> accountInfo = {};
  Map<String, dynamic> personalInfo = {};

  final RxList<Map<String, dynamic>> interests = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInterests();
    for (var goal in goals) {
      selectedGoals[goal] = false;
    }
  }

  // call for services
  final SignUpService _signUpService = SignUpService();
  final IdCheckService _idCheckService = IdCheckService();

  Future<void> nextStep() async {
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
      String? result = await checkId(
          File(frontImagePath.value), firstName.text, lastName.text);
      if (result != null) {
        Loaders.warningSnackBar(
          title: 'Id Validation Error',
          message: result,
        );
      }
      // Validate Step 2
      if (formKeyStep2.currentState!.validate() &&
          this.frontImagePath.value.isNotEmpty &&
          this.backImagePath.value.isNotEmpty &&
          result == null) {
        currentStep.value++;
        pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    } else if (currentStep.value == 2) {
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

  Future<void> pickImage(RxString imagePath) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath.value = image.path;
    }
  }

  // Method for verifying ID validity

  Future<String?> checkId(
      File frontIdImage, String firstName, String lastName) async {
    File resizedImage = await Formatter.resizeImage(frontIdImage);
    // Extract text from the ID image
    final message = await _idCheckService.extractTextFromImage(resizedImage);
    if (message != null) {
      // Check if the extracted text contains the Moroccan ID card phrase
      if (!message!.contains("ROYAUME DU MAROC") &&
          !message!.contains("CARTE NATIONALE D'IDENTITE")) {
        return "It is not a Moroccan ID card.";
      }
      // Check if the extracted name and surname match the ones entered
      else if (!message.toLowerCase().contains(firstName.toLowerCase()) ||
          !message.toLowerCase().contains(lastName.toLowerCase())) {
        return "First name and last name do not match.";
      }
      // Check if the extracted text is valid (not blurry or unreadable)
      else if (message.contains("Erreur") || message.isEmpty) {
        return "The image is blurry, or the text could not be extracted correctly.";
      }
    } else {
      return null;
    }
  }

  // Method for selecting the date
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

  // Method to update the selected gender
  void setGender(String gender) {
    selectedGender.value = gender;
  }

  // Interests Part
  Future<void> loadInterests() async {
    try {
      final List<Category> data = await categoryService.fetchCategories();
      interests.value = data.map((category) {
        final String iconName = category.iconName ?? 'help_outline';
        print("iconName: $iconName");
        // Nom de la catégorie
        final String categoryName = category.name;

        // Récupérer l'icône correspondante ou utiliser une icône par défaut
        final iconData = iconMapping[iconName] ?? Icons.help_outline;

        // Initialiser l'état de sélection des intérêts
        selectedInterests[categoryName] = false;

        // Retourner les données formatées
        return {
          'name': categoryName,
          'icon': iconData,
        };
      }).toList();
    } catch (e) {
      // Gestion des erreurs et log de l'erreur
      print("Erreur lors du chargement des intérêts : $e");
    }
  }

  // Method to toggle the selection state of an interest
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

  // Method to change the selection state of a goal
  void toggleGoal(String goal) {
    selectedGoals[goal] = !selectedGoals[goal]!;
  }

  Future<void> signup() async {
    accountInfo = {
      'username': username.text.trim(),
      'email': email.text.trim(),
      'password': password.text.trim(),
    };
    print(accountInfo);
    preparePersonalInfo();
    try {
      final emailAndUsernameCheck = await _signUpService.checkEmailAndUsername({
        'username': username.text.trim(),
        'email': email.text.trim(),
      });
      if (emailAndUsernameCheck == true) {
        String verificationCode = HelperFunctions.generateVerificationCode();
        print("-----------MySecretCode-----------");
        print(verificationCode);
        // Send a verification email instead of creating the account right away
        bool success = await _signUpService.sendVerificationEmail(
            email.text.trim(), verificationCode);
        if (success) {
          Future<String?> tokenFuture = createAccount();
          // Await the token before passing it to savePersonalInfo
          String? token = await tokenFuture;
          // Now pass the resolved value (String?) to savePersonalInfo
          await savePersonalInfo(token);
          Get.to(() => VerifyEmailScreen(
              email: email.text.trim(), code: verificationCode));
        } else {
          Loaders.errorSnackBar(
              title: 'Verification Failed',
              message: 'Could not send verification email. Please try again.');
        }
      } else {
        Loaders.errorSnackBar(
          title: 'Registration Failed',
          message: 'Username or email already exists. Please try another.',
        );
      }
    } catch (e) {
      Loaders.errorSnackBar(title: 'Erreur', message: e.toString());
    }
  }

  Future<String?> createAccount() async {
    var token = await _signUpService.createAccount(accountInfo);
    return token;
  }

  Future<void> savePersonalInfo(String? token) async {
    await _signUpService.savePersonalInfo(personalInfo, token);
  }

  @override
  void onClose() {
    birthDate.dispose();
    super.onClose();
  }

  void preparePersonalInfo() async {
    // Filter interests
    List<String> filteredInterests =
        (selectedInterests.value as Map<String, bool>)
            .entries
            .where((entry) => entry.value == true)
            .map((entry) => entry.key)
            .toList();

    // Encode images to Base64
    String idFaceBase64 =
        await encodeImageToBase64(frontImagePath.value.trim());
    String idBackBase64 = await encodeImageToBase64(backImagePath.value.trim());
    String profilePictureBase64 =
        await encodeImageToBase64(profileImagePath.value.trim());

    // Convert phoneNumber to a number if needed
    var phoneNumberValue = phoneNumber.text.trim();
    var phoneNumberNumeric =
        int.tryParse(phoneNumberValue); // Try to parse as int
    if (phoneNumberNumeric == null) {
      print("Le numéro de téléphone n'est pas valide.");
      phoneNumberNumeric = 0; // Handle as necessary
    }

    // Convert date of birth to DateTime and format it to yyyy-MM-dd
    String birthDateString = birthDate.text.trim();
    DateTime? birthDateParsed;
    try {
      // Parse the date using the current format (1/12/2024 or 01/12/2024)
      birthDateParsed = DateFormat("d/M/yyyy")
          .parse(birthDateString); // day/month/year format
    } catch (e) {
      print("Erreur de format de date : $e");
      birthDateParsed = null; // Handle as needed, set default or null
    }

    // Format date to yyyy-MM-dd
    String? formattedBirthDate = birthDateParsed != null
        ? DateFormat("yyyy-MM-dd")
            .format(birthDateParsed) // Convert to the desired format
        : null;

    // Populate personalInfo
    personalInfo = {
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'phoneNumber': phoneNumberNumeric, // Store as number
      'dateBirth': formattedBirthDate, // Store the formatted date
      'gender': selectedGender.value.trim(),
      'description': 'update your Bio',
      'idFace': idFaceBase64,
      'idBack': idBackBase64,
      'profilePicture': profilePictureBase64,
      'userName': username.text.trim(),
      'interests': filteredInterests
    };

    print(personalInfo['dateBirth']); // Debugging output
  }

// Helper function to encode an image file to Base64
  Future<String> encodeImageToBase64(String imagePath) async {
    try {
      File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        List<int> imageBytes = await imageFile.readAsBytes();
        return base64Encode(imageBytes);
      } else {
        print('Image file not found at path: $imagePath');
        return '';
      }
    } catch (e) {
      print('Error encoding image: $e');
      return '';
    }
  }
}
