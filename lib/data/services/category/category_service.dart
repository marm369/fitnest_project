import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configuration/config.dart';
import '../../../features/events/models/category.dart';

class CategoryService {
  final String gatewayBaseUrl = '$GatewayUrl/event-service';

  Future<List<Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('$gatewayBaseUrl/api/categories/getCategories'));

    if (response.statusCode == 200) {
      // Décoder la réponse en UTF-8
      String utf8Body = utf8.decode(response.bodyBytes);
      List<dynamic> data = json.decode(utf8Body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
