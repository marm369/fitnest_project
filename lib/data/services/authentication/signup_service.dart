import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configuration/config.dart';

class SignUpService {
  // Définir l'URL de base pour le service d'authentification
  final String authUrl = '$GatewayUrl/auth-event';

  // URL pour vérifier le nom d'utilisateur et l'adresse e-mail
  late final String emailUrl = '$authUrl/check';

  // URL pour créer un compte
  late final String registerUrl = '$authUrl/register';

  // URL pour ajouter des informations utilisateur
  late final String userUrl = '$authUrl/users/add';

  // URL pour vérifier l'adresse e-mail
  late final String emailVerifyUrl = '$authUrl/verify-email';

  // Method to check if the email or the username exists already in the DB
  Future<bool?> checkEmailAndUsername(
      Map<String, dynamic> emailUsername) async {
    try {
      final response = await http.post(
        Uri.parse(emailUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(emailUsername),
      );
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 409) {
        return false;
      }
    } catch (e) {
      print('Connexion Error: $e');
      return false;
    }
  }

  // Method to verify the email
  Future<void> sendVerificationEmail(String email) async {
    final url = Uri.parse('$GatewayUrl/send-verification-email');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        print('Verification email sent successfully');
      } else {
        print('Failed to send email: ${response.body}');
      }
    } catch (e) {
      print('Error sending verification email: $e');
    }
  }

  // Method to create an account and retrieve a token
  Future<String?> createAccount(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.post(
        Uri.parse(registerUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );
      if (response.statusCode == 200) {
        final token = jsonDecode(response.body)['token'];
        return token;
      } else {
        print('Erreur de création de compte: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Connexion Error: $e');
      return null;
    }
  }

  // Method to save personal information
  Future<void> savePersonalInfo(
      Map<String, dynamic> personalInfo, String token) async {
    try {
      final response = await http.post(
        Uri.parse(userUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(personalInfo),
      );
      if (response.statusCode == 200) {
        print('Personal information saved');
      } else {
        print('Error saving personal information: ${response.statusCode}');
      }
    } catch (e) {
      print('Connexion Error: $e');
    }
  }
}
