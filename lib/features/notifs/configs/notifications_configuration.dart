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

Future<String?> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "fitnest-6980d",
    "private_key_id": "90cd9491ae738ca20d5f4649fbb1e1b062120e1a",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCjzmqDHxqt1vEn\nDI3T/QxHOdZxbb517IogZsDu5IkkkPCxJvqhgoUYsXE2Hy6GGC6c3/w6cDv4Yt17\nNjAv//ROq+mIN6St+M9OJV76kOH6H+O/s3voI10XCXns3r+OFQqixC3/ziuDn9pf\nLiFQ87HcaT2Tv1bJzHFZMLvtwKjZ3PBFoohvwdXYSch7C//gn4z7lq1XC7BGPmgh\nlfw+4uom40TtJ3ZLgj86RsiYSQBlKmLjic+UbwBnneZ9TVdIqBzWr0GQgkYWaGG0\nHof4Q10UfBbCmAu7pXrSR9yPre/SIyRDIxAIPYaa2cU8vO15sdUgWRw6OwC4K9oJ\nyndgBPCHAgMBAAECggEADg1JCdKDQWJs8YKcMBFHGl0Vzkkxy3/tIXZvGo80TJS6\ncRf87Bn8PPAL3C60mQA+D2sPghvaqSYiBc3SOGvmk1EgCXVshRgRAI0oJqqDGCfg\nK7PD71gJRk6jzPQWzqNzdB8MKyOOjA4Md5nHdeBR46yLgb8qPMly98m8dVrPoVC1\nekIljSGqXJFiSijmNac+46WbNSc8P1kizDy3SfFLEhQKW5NrQAlvTZHSYZJlRZze\ng4uVpM+dN3Kk7/hzNjsbH1Bo/YzRKnaQnOBVEIG3MpJVW9L97OmMEu7bcNZq0yyg\n/tvZMEPi5v6JH2DIW2m2lsHntzSUFG4tObOFf3GU4QKBgQDcE/T7M7pADBS7ivae\nlh//3dNRkFoz4EBw9GNyqk51fhdCNvd/0agfMeTUwdU3UbsDDp9kjuKoCPnkw9Cf\nG51iBKE9YKGLFxcZGrorQnz4zmgTqBg2agM4n5gB9C8oV8ANVgRNOXwRtamYkep5\noQU30gQCnCyIggFcwcJ9QcrgWQKBgQC+iyBmj/EFzduryTu0Ozkg+X6PpuOxd1LW\nPMrrojbJ7iRrpIegWQkOgFza0iL3nNq9tPIDjBf0mUvseiE7A3/JAilS376L2v4W\nQzIvUY/DP1w8A/0oeIuJfAwuxU2dyUd8xEgyLpqyyIbHCURNlnZtYZ3vZqwN+iN+\nG0gJSG873wKBgQClLUVdlMFheK/G4tGezUZPIAqO2S0aamFzZbmOQkyI2o5SYDb6\ndD0ezK/XD3QcBPe7n6n6K1PqknIcROu7v1osSxVJn9EfN8FaUjkQZuKtSx3KQwuJ\nK6AnS4EnVkJeoR2/5KNt4otAL3yOylWV3EiyUKo520WBXzHukG6M3GiMYQKBgFSs\nOJq7Dk0Y/KwrAXgG9U0c8cveSsJ7FvmTDE2HyTcUt2SKOabcyfSCwECRLu6/6khx\nFzbSU3bjhGSypP+3f1qQtlJYkTFPAKhd9fgnE26dQlx9HUuVvdQ7pqJGFUavwi/E\nfZynLyGRkKr0CEE+QqQ6w9c11fFkHc+VSf6uDJgbAoGAfYI6KdlM5UT+/ysmauH4\nty7Yt69nldImPMP3eyQKC0QYw4wGz+6E/ScoaHwNwQJ81GEai0luLsvnqN2BM89G\n7DadpPUGxTi4Rq2/k7e7S9CbkTf2sfx0mI4iQXzhgHSIkOuUj2xUN3gJ9dxyHRpW\nJHdto8xdEbqXB20gAK1OmlI=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-b4on3@fitnest-6980d.iam.gserviceaccount.com",
    "client_id": "106504251934407321033",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-b4on3%40fitnest-6980d.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

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

    print ("access token : $serverKeyAuthorization");

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
    await storeNotification(notification, eventid);
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

