import 'package:http/http.dart' as http;
import 'dart:convert';

class ChangeUsernameService {
  // URL de l'API pour changer le nom d'utilisateur
  final String authUrl =
      'http://172.20.214.77:8080/auth/change-username'; // Mettez à jour l'URL de l'API si nécessaire.

  // Méthode pour changer le nom d'utilisateur
  Future<String?> changeUsername(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );

      // Vérification du code de statut de la réponse
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Retourner un token ou une autre donnée de la réponse (comme une confirmation)
        return responseData['token']; // Si la réponse contient un token
      } else {
        // Si le code de statut n'est pas 200, afficher l'erreur
        print(
            'Erreur lors du changement de nom d\'utilisateur: ${response.body}');
        return null; // Retourne null si la requête échoue
      }
    } catch (e) {
      // Gestion d'erreur en cas de problème avec la requête HTTP
      print('Erreur lors de la requête HTTP: $e');
      return null;
    }
  }
}
