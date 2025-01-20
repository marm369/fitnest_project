import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../../../configuration/config.dart';
import '../configs/notifications_configuration.dart';

/// Stores a notification by calling the `/post` endpoint.
Future<void> storeNotification(NotificationModel notification, int eventId) async {
  const String apiUrl = "$GatewayUrl/notif-service/api/notifs/post";

  try {
    // Prepare the request body.
    Map<String, dynamic> requestBody = {
      "recipient": notification.recipient,
      "type": notification.type,
      "content": notification.content,
      "token": notification.token,
      "eventid": eventId, // Add event ID to the request body
    };

    // Make the HTTP POST request.
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(requestBody),
    );

    // Check the response status.
    if (response.statusCode == 201) {
      print("Notification stored successfully!");
    } else {
      throw Exception(
          "Failed to store notification with status code ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error storing notification: $e");
  }
}

Future<List<NotificationModel>> fetchUserNotifications( int userid) async {
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

