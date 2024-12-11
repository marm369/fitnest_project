import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import '../../../configuration/config.dart';
import '../models/fcmtoken_model.dart';

///----------------------------------------------------------------------------

final _firebaseMessaging =  FirebaseMessaging.instance;
Future<void> initializeToken(double userId) async {
  try {
    await _firebaseMessaging.requestPermission();

    deviceToken = await _firebaseMessaging.getToken();

    if (deviceToken != null) {
      print("===================Device FirebaseMessaging Token====================");
      print(deviceToken);
      print("===================Device FirebaseMessaging Token====================");

      await insertTokenIntoDatabase(deviceToken!, userId );
    }
  } catch (e) {
    print("Error retrieving FCM token: $e");
  }
}

Future<List<fcmtokenModel>> fetchAll() async {
  // await ConfigureNotifications(userid);
  final String apiUrl = "$GatewayUrl/notif-service/api/fcm-token/get/all";

  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((notif) => fcmtokenModel.fromJson(notif)).toList();
    } else {
      throw Exception(
          "Failed to load notifs with status code ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error fetching notifs: $e");
  }
}

Future<void> insertTokenIntoDatabase(String token, double userId) async {
     final requestBody = {'token': token, 'userid': userId};

     final response = await http.post(
       Uri.parse('$GatewayUrl/notif-service/api/events/createEvent'),
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(requestBody),
     );

     if (response.statusCode == 200) print("token was set seccessfuly");
}

