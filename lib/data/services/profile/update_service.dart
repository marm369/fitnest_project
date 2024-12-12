import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';

class UpdateService {
  final box = GetStorage();
  int? userId;
  String? token;

  UserService() {
    userId = box.read('user_id');
    token = box.read('token');
  }

  final String updateUrl = '$GatewayUrl/auth-service';

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

  Future<bool?> updateUsername(Map<String, dynamic> accountInfo) async {
    try {
      print("Account Info");
      print(accountInfo);
      final response = await http.put(
        Uri.parse('$updateUrl/account/update-username'),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
        body: jsonEncode(accountInfo),
      );
      print(response.statusCode);
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
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token"
        },
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
