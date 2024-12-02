import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../../data/services/authentication/id_check_service.dart';
import '../../../../data/services/authentication/signup_service.dart';
import '../../../../data/services/profile/user_service.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/formatters/formatter.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../../../../utils/popups/loaders.dart';
import '../../../../utils/validators/validation.dart';
import '../../../network_manager.dart';


class SignupController extends GetxController {
  static SignupController get instance => Get.find();
  final NetworkManager networkManager = Get.put(NetworkManager());

  final ImagePicker _picker = ImagePicker();
  final pageController = PageController();

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
    final message = await _idCheckService.extractTextFromImage(frontIdImage);
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
      // Check for the validity date, assuming the format "Valide jusqu'au dd.MM.yyyy"
      else if (message.contains("Valable jusqu'au")) {
        final dateRegex = RegExp(r"Valable jusqu'au (\d{2}.\d{2}.\d{4})");
        final dateMatch = dateRegex.firstMatch(message);

        if (dateMatch != null) {
          final expiryDateString = dateMatch.group(1);
          final DateTime expiryDate =
              DateFormat('dd.MM.yyyy').parse(expiryDateString!);
          print(expiryDate);
          final DateTime currentDate = DateTime.now();

          if (expiryDate.isBefore(currentDate)) {
            return "The ID card has expired.";
          } else {
            return "The ID card is valid.";
          }
        } else {
          return "Validity date not found on the card.";
        }
      }

      // Check if the extracted text is valid (not blurry or unreadable)
      else if (message.contains("Erreur") || message.isEmpty) {
        return "The image is blurry, or the text could not be extracted correctly.";
      } else {
        return null;
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
      // Appel de la méthode du service
      //final data = await _userService.fetchInterests();
      final data = null;
      // Data transformation to match the controller variables
      interests.value = data.map((category) {
        final iconName = category['iconName'] as String? ?? 'help_outline';
        final categoryName = category['name'] as String;
        final iconData = iconMapping[iconName] ?? Icons.help_outline;

        // Initialize interest selection
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
    try {
      FullScreenLoader.openLoadingDialog(
          'Processing your information...', MyImages.loadingIllustration);
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        Loaders.errorSnackBar(
          title: 'Connection Failed',
          message: 'Please check your Internet connection.',
        );
        return;
      }

      final emailAndUsernameCheck = await _signUpService.checkEmailAndUsername({
        'username': username.text.trim(),
        'email': email.text.trim(),
      });
      if (emailAndUsernameCheck == true) {
        /* // Send a verification email instead of creating the account right away

        final verificationToken = await _signUpService.sendVerificationEmail({
          'email': email.text.trim(),
        });

        if (verificationToken != null) {
          Get.to(() => VerifyEmailScreen(email: email.text.trim()));
        } else {
          Loaders.errorSnackBar(
            title: 'Verification Failed',
            message: 'Could not send verification email. Please try again.',
          );
        }*/
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

  @override
  void onClose() {
    birthDate.dispose();
    super.onClose();
  }
}
