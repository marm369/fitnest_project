import 'package:http/http.dart' as http;
import 'dart:convert';

class AccountService {
  final String authUrl = 'http://172.20.214.71:8080/auth/register';
  final String userUrl = 'http://172.20.214.71:8080/users/add';

  // Méthode pour créer un compte et récupérer un token
  Future<String?> createAccount(Map<String, dynamic> accountInfo) async {
    final response = await http.post(
      Uri.parse(authUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(accountInfo),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['token']; // Retourne le token de la réponse
    } else {
      print('Erreur de création de compte: ${response.body}');
      return null;
    }
  }

  // Envoi des informations personnelles avec le token
  Future<void> savePersonalInfo(
      Map<String, dynamic> personalInfo, String token) async {
    final response = await http.post(
      Uri.parse(userUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token", // Ajoute le token
      },
      body: jsonEncode(personalInfo),
    );

    if (response.statusCode == 200) {
      print('Informations personnelles sauvegardées');
    } else {
      print('Erreur: ${response.body}');
    }
  }
}
