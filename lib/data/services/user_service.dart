import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../configuration/config.dart';

class UserService {
  final box = GetStorage();
  // Méthode pour récupérer le nom de l'utilisateur
  Future<String> fetchUserName(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/username');
    String? token = box.read('token');
    print("le token est $token");
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Erreur lors de la récupération du nom d\'utilisateur');
      }
    } catch (e) {
      throw Exception('Connexion Error: $e');
    }
  }
}
