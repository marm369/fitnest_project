import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';
import '../../../features/profile/models/user_model.dart';

class UserService {
  final box = GetStorage();
  String? token;
  final String gatewayAthUrl = '$GatewayUrl/auth-service';

  UserService() {
    token = box.read('token');
  }
  // Method to fetch the username
  Future<String> fetchUserName(int userId) async {
    final url = Uri.parse('$gatewayAthUrl/user/$userId/username');

    try {
      final response = await http.get(
        url,
        headers: {
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Error retrieving username');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

// Method to fetch profile data
  Future<UserModel> fetchProfileData(int userId) async {
    print("-----------");
    print(userId);
    final url = Uri.parse('$gatewayAthUrl/user/getUserById/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Error loading profile data');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  // Method to fetch profile data and return JSON
  Future<Map<String, dynamic>> fetchProfileDataAsJson(int userId) async {
    final url = Uri.parse('$gatewayAthUrl/user/getUserById/$userId');
    try {
      final response = await http.get(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Error loading profile data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }
}
