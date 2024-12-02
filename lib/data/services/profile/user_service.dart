import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';
import '../../../features/events/models/user_model.dart';

class UserService {
  final box = GetStorage();
  String? token;
  final String gatewayAthUrl = '$GatewayUrl/auth-service';
  final String gatewayEventUrl = '$GatewayUrl/event-service';

  UserService() {
    token = box.read('token');
    print("Token: $token");
    if (token == null) {
      throw Exception("Token is null. Please log in again.");
    }
  }

  // Method to fetch username by userId
  Future<String> fetchUserName(int userId) async {
    final url = Uri.parse('$gatewayAthUrl/user/$userId/username');
    print("Token is $token");

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
        throw Exception('Error retrieving username: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  // Method to fetch events organized by a user
  Future<List<Event>> fetchUserEvents(int userId) async {
    final url = Uri.parse('$gatewayEventUrl/api/events/associated/$userId');
    print("Fetching events for user ID: $userId");
    try {
      final response = await http.get(
        url,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          if (responseData == null || responseData.isEmpty) {
            print('empty responsedata ');
            return [];
          }
          print('responsedata $responseData');
          return List<Event>.from(responseData.map((e) => Event.fromJson(e)));
        } else {
          throw Exception("Failed to load events");
          return [];
        }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }

  // Method to fetch profile data by userId
  Future<UserModel> fetchProfileData(int userId) async {
    final url = Uri.parse('$gatewayAthUrl/user/getUserById/$userId');
    print("Fetching profile data for user ID: $userId");

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
        throw Exception('Error loading profile data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection Error: $e');
    }
  }
}
