import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../../../configuration/config.dart';

Future<List<NotificationModel>> fetchUserNotifications( double userid) async {
  // await ConfigureNotifications(userid);
  const String apiUrl = "http://192.168.1.14:8888/notif-service/api/notifs/get/1";
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