import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnest/data/services/participation/participation_service.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import 'package:fitnest/features/notifs/services/notifications_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnest/features/notifs/services/fcmToken_service.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:fitnest/configuration/config.dart';
import 'package:fitnest/features/notifs/controller/notification_helper.dart';

import '../../../configuration/config.dart';

Future<String?> getAccessToken() async {
  final serviceAccountJson = fcmserverapikey;
  try{
  List<String> scopes = [
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);
  // get the access  token
  auth.AccessCredentials credentials =
  await auth.obtainAccessCredentialsViaServiceAccount(
    auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
    scopes,
    client,
  );
  client.close();
  print("Access Token: ${credentials.accessToken.data}"); // Print Access Token
  return credentials.accessToken.data;
  } catch (e) {
    print("Error getting access token: $e");
    return null;
  }
}

Map<String, dynamic> getBody({required String fcmToken, required String title, required String body, required String userId, String? type, }){
  return {
    "message": {
      "token": fcmToken,
      "notification": {"title": title, "body": body},
      "android": {
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default"
        }
      },
      "apns": {
        "payload": {
          "aps": {"content_available": true}
        }
      },
      "data": {
        "type": type,
        "id": userId,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    }
  };
}

//Future<void> sendNotifications({required String fcmToken, required String title, required String body, required String userId, String? type,}) async {
Future<void> sendNotifications(NotificationModel notification, int eventid, String? type) async {
  try {
    var serverKeyAuthorization = await getAccessToken();

    const String urlEndPoint = "https://fcm.googleapis.com/v1/projects/fitnest-6980d/messages:send";

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = 'Bearer $serverKeyAuthorization';

    var response = await dio.post(
      urlEndPoint,
      data: getBody(
        userId: notification.recipient.toString(),
        fcmToken: notification.token,
        title: notification.type,
        body: notification.content,
        type: type ?? "message",
      ),
    );
    print("response data : $response");
  } catch (e) {
    print("Error sending notification: $e");
  }
}
/*
Future<void> sendNotifications1({
  required String fcmToken,
  required String title,
  required String body,
  required String userId,
  String? type,
}) async {
  try {
    // Retrieve the access token
    var serverKeyAuthorization = await getAccessToken();
    if (serverKeyAuthorization == null) {
      throw Exception("Failed to retrieve access token");
    }

    // FCM endpoint
    const String urlEndPoint =
        "https://fcm.googleapis.com/v1/projects/fitnest-6980d/messages:send";

    // Define the message payload
    final Map<String, dynamic> message = {
      "message": {
        "token": fcmToken,
        "notification": {
          "title": title,
          "body": body,
        },
        "data": {
          "userId": userId,
          "type": type ?? "message",
        },
      }
    };

    // Send the notification
    final response = await http.post(
      Uri.parse(urlEndPoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKeyAuthorization',
      },
      body: jsonEncode(message),
    );

    // Handle the response
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.statusCode}');
      print('Response: ${response.body}');
    }
  } catch (e) {
    print("Error sending notification: $e");
  }
}
*/

Future<void> configureNotifications(int userId) async {

  final ParticipationService participationService =ParticipationService();
  final FcmtokenService _fcmTokenService = FcmtokenService(participationService);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAiqgGAGkAAD2RazL_g6wG8WwMlN07YuoE",
      appId: "1:1068465758439:android:2f37a8d3e960370e360242",
      messagingSenderId: "1068465758439",
      projectId: "fitnest-6980d",
    ),
  );

  print("Notifications configured");

  await FirebaseMessaging.instance.requestPermission();

  final NotificationsHelper notificationsHelper = NotificationsHelper();
  await notificationsHelper.initNotifications();
  notificationsHelper.handleBackgroundNotifications();

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? deviceToken = await messaging.getToken();

  if (deviceToken != null) {
    print("FCM Token: $deviceToken");
    await _fcmTokenService.insertTokenIntoDatabase(deviceToken, userId);
    print("token was persisted ");
  } else {
    print("Failed to retrieve FCM token.");
  }
}

