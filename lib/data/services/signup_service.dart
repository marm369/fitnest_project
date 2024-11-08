import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpService {
  final String authUrl = 'http://192.168.43.97:8080/auth/register';
  final String userUrl = 'http://192.168.43.97:8080/users/add';

  // Méthode pour créer un compte et récupérer un token
  Future<String?> createAccount(Map<String, dynamic> accountInfo) async {
    try {
      // Envoi de la requête POST avec 'http'
      final response = await http.post(
        Uri.parse(authUrl), // Utilisation de Uri.parse() avec http.post
        headers: {"Content-Type": "application/json"}, // Headers appropriés
        body: jsonEncode(accountInfo), // Corps de la requête JSON
      );
      if (response.statusCode == 200) {
        // Décodage de la réponse JSON
        final token = jsonDecode(response.body)['token'];
        return token; // Retourne le token de la réponse
      } else {
        print('Erreur de création de compte: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erreur de connexion: $e');
      return null;
    }
  }

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
        print('Informations personnelles sauvegardées');
      } else {
        print(
            'Erreur lors de l\'enregistrement des informations personnelles: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de connexion: $e');
    }
  }
}
