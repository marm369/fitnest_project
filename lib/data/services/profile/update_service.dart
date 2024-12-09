import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../configuration/config.dart';

class UpdateService {
  final box = GetStorage();
  int? userId;

  UserService() {
    userId = box.read('user_id');
  }

  final String updateUrl = '$GatewayUrl/auth-service';
  // Method to update user information
  Future<bool?> updateInfos(
      int userId, Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.put(
        Uri.parse('$updateUrl/user/$userId'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );
      // Check the status code of the response
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return true; // If the response contains a token
      } else {
        // If the status code is not 200, display the error
        print('Error updating user information: ${response.body}');
        return false; // Return null if the request fails
      }
    } catch (e) {
      // Error handling in case of issues with the HTTP request
      print('Error with the HTTP request: $e');
      return false;
    }
  }

  Future<bool?> updateUsername(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.put(
        Uri.parse('$updateUrl/account/update-username'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return true;
      } else {
        print('Error updating user information: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error with the HTTP request: $e');
      return false;
    }
  }

  Future<bool?> updateEmail(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.put(
        Uri.parse('$updateUrl/account/update-email'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return true;
      } else {
        print('Error updating user information: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error with the HTTP request: $e');
      return false;
    }
  }
}
