import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';

class SignInService {
  final String authUrl = '$GatewayUrl/auth-service';
  final box = GetStorage();

  // Method to sign in and retrieve a token
  Future<String?> signIn(Map<String, dynamic> accountInfo) async {
    try {
      final response = await http.post(
        Uri.parse('$authUrl/auth/authenticate'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(accountInfo),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        if (jsonResponse['token'] != null) {
          print("Maintenant je suis ici j'enregistere dans le local storage");
          box.write('user_id', jsonResponse['user_id']);
          box.write('token', jsonResponse['token']);
          print(box.read('user_id'));
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
