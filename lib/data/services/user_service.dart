import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://192.168.0.128:8080';
  final box = GetStorage();
  // Méthode pour récupérer le nom de l'utilisateur
  Future<String> fetchUserName(int userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/username');
    String? token = box.read('token');
    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['username'];
      } else {
        throw Exception('Erreur lors de la récupération du nom d\'utilisateur');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }
}
