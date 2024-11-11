import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../configuration/config.dart';

class UserService {
  Future<List<dynamic>> fetchInterests() async {
    try {
      final response = await http.get(
        Uri.parse('http://172.20.211.57:8080/api/categories/getCategories'),
      );
      if (response.statusCode == 200) {
        final data =
            json.decode(utf8.decode(response.bodyBytes)) as List<dynamic>;
        return data;
      } else {
        throw Exception('Error loading categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error loading interests: $e");
    }
  }
}
