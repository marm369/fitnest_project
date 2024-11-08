import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'http://172.20.210.205:8080/api';

  Future<List<dynamic>> fetchInterests() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories/getCategories'),
      );

      if (response.statusCode == 200) {
        // Décoder et renvoyer les données JSON
        final data =
            json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return data;
      } else {
        throw Exception(
            'Erreur lors du chargement des catégories : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Erreur lors du chargement des intérêts : $e");
    }
  }
}
