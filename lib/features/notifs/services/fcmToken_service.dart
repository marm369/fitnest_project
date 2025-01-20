import 'dart:convert';
import 'package:fitnest/data/services/participation/participation_service.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../models/fcmtoken_model.dart';

class FcmtokenService {
  ParticipationService participantsService ;
  FcmtokenService(this.participantsService);

  final String _baseUrl = '$GatewayUrl/notif-service/api/fcm-token';

  Future<List<fcmtokenModel>> fetchAll() async {
    final String apiUrl = "$GatewayUrl/notif-service/api/fcm-token/get/all";
    print('fcmtokens + ${apiUrl}');
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );
      print('response $response');
      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((notif) => fcmtokenModel.fromJson(notif)).toList();
      } else {
        print("Failed to load notifs with status code ${response.statusCode}");
        return [];  // Retourne une liste vide au lieu de throw
      }
    } catch (e) {
      print("Error fetching notifs: $e");
      return [];  // Retourne une liste vide au lieu de throw
    }
  }

  Future<fcmtokenModel?> fetchToken(dynamic userId) async {
    final String apiUrl = "$_baseUrl/get/$userId";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return fcmtokenModel.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<fcmtokenModel?>> fetchExistingParticipantTokens(int eventId) async {
    try {
      List<dynamic> participations = await participantsService.getParticipationsByEventId(eventId);
      List<fcmtokenModel?> tokens = [];

      for (var participation in participations) {
        var userId = participation['userId'];
        var tokenData = await fetchToken(userId);
        if (tokenData != null && tokenData.token.isNotEmpty) {
          tokens.add(tokenData);
        }
      }

      return tokens;
    } catch (e) {
      throw Exception('Error fetching participant tokens: $e');
    }
  }

  Future<void> insertTokenIntoDatabase(String token, int  userId) async {
    final requestBody = {'token': token, 'userid': userId};
     print("request body : $requestBody");
    final response = await http.post(
      Uri.parse('$GatewayUrl/notif-service/api/fcm-token/associate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    ).timeout(const Duration(seconds: 10));
    print ("response : $response");
    if (response.statusCode == 200) {
      print("Token was set successfully");
    }
  }
}
