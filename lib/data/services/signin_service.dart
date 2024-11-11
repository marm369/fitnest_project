import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../configuration/config.dart';

class SignInService {
  final String authUrl = '$baseUrl/auth/authenticate';
  final box = GetStorage();

  // Method to sign in and retrieve a token
  Future<String?> signIn(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.post(
        Uri.parse(authUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['token'] != null) {
          box.write('user_id', jsonResponse['user_id']);
          box.write('token', jsonResponse['token']);
          return jsonResponse['token'];
        } else {
          print('Token is missing in the response');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Incorrect login or password');

        return null;
      }
    } catch (e) {
      print('Connection error: $e');
      return null;
    }
  }
}
