import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../../../configuration/config.dart';
import '../configs/notifications_configuration.dart';

Future<List<NotificationModel>> fetchUserNotifications( double userid) async {
  const String apiUrl = "$GatewayUrl/notif-service/api/notifs/get/1";
      //"$GatewayUrl/notif-service/api/notifs/get/$userid";
  try {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      print(jsonData);
      return jsonData.map((notif) => NotificationModel.fromJson(notif)).toList();
    } else {
      throw Exception(
          "Failed to load notifs with status code ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error fetching notifs: $e");
  }
}