import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
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
    "private_key_id": "6c4853112b4384296699c54fb74945edbb73ff66",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDOcNeqIM23fi2P\nMGu1mdcuTVfk2O3J5FF1eqojmRGEqLBoQVwTO9dj17XgXs+xu+8GwzdgbyvEXWHM\nt9Nsivpw08nDnhBBJ9qC3wZ/wvhepN1j/dCNPqnPHBOHRVsnRaLRHVa44TRa2CW+\n5OJFFvHF6xrCgaAgfLeXNUwqKeLG1Dqh8jn07sCHCvES7angZQtI2C6/uTXS0PVf\n+MSMNh+AtjsOMMj3Q1z1dJ5pPNH+/ycJJgf6Mi8hmEpdx1tz1gfl4qddPoJOtz0b\nTAzW5uCAXSantYTcbYr0GyZqOB/9dDCirvD5LoX+ZTZ/MdIZ+1BBjBwehmaNtRF+\nt0HJLGUvAgMBAAECggEAPsKnjh0y7Vn619FMrYT7miQBWJ1qjTpQWXrVRsU+QipW\nlxtntqE2ti/aJ0ArvEj6PgATUcn6cFRDa01nhVQrFyoL6OCg6G4JTEgpXaYUhBFz\nDPcY9Bfc4A4VEcbQE3xkJ1bYCpTMqeGUeBh1gbOcBSOYmxF1cOr5lYqqgRcCzpcj\nAPaNuM3S4Og/x9qZDD4CSDzBaLi163s33m++t4ejX101KTDHIsXxqNPZ7WldXm9X\n2f5CXEKeUJG2WsqSIGXOawwH9Iq62fGK2eZCSC4u+kM98EbqEx9KPZC/oLZMsmCL\nXu1FelA8yGzDMgujVNz8i0IAmQaEl9UFLmSV7FlNAQKBgQDpJY8oIjInPT3Alv6x\n3/g0UoB2hn3C+p4QEdZXIhIthUtmtR1YB2qNRMGcKluchT4fxj/0TWb2h2B4IyAE\nw2RG67HIZF3lVXLrZ3aW6ak7nsuCHN80c7uYM2xQkpg4fVl8cXgf+rXIyG80rGrP\nJ/NztlUAW6BYt1NVgDbaKWZ/4QKBgQDirSQglPckYVoOGW30eGTXSw3yOtmBsf9a\nxgtwWnxpIRUlkrdweuiirwkCVQpKFnL7HWeJffXLcwDKaRpmopGIBTWct12C9YKM\ndFirp6VEj4N0fnCfvLV6He1REceDELb5etr3wF0z7OiL4u41W5ey6RTuszwEgTLz\nnIT5kyPHDwKBgG/aty3YChvNQ90sFBGelGP12PAEYj2zIzYueJjhHbt9IcmqxuM+\n253fCMw1fjI/sqhn4rMAl49bL6sznt7qJyfnWCn+DRZDwpix0LFidPDHpHdOBsAR\nbkT9FtApJKKlcNNFVQ5yp9gmYUPyHGQ6lJBFP86mJu2pNm/kzWwpRKXBAoGAb2Ha\njbQFGLhJcwIl2GnMS0oTCULHnAYlzqnf9w5Pca0S4gqM3tVWOJI/oAi/bJZJW4Eg\nXhwpyhWxfsRUd7hMQIUmyeIELhSLWI7W/0n6WI0YcAatOqCUn/PSp/JPkeSFtGMc\n835vjdNMlWgl2swt53jGk2A5DpGZwsDXSnd1rhsCgYBiS1ZiCI3Y0Nc4TSzTiPnN\naXS7N3qWQMBOQWkUILJqzJNrh5J9S6bAkb3ANpsd3gv2PYq4kDvlsEIHuNvBk0Hb\naghQEq/avIG334ftZ8rGruLERkCQiZkTxp0GgT5eRKKcS1JJWGGmyzLOqUv0GC/C\nHgtFqqOl2Tdj75braUxP6w==\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-b4on3@fitnest-6980d.iam.gserviceaccount.com",
    "client_id": "106504251934407321033",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-b4on3%40fitnest-6980d.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  }
  ;

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
Future<void> sendNotifications(NotificationModel notification, String? type) async {
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

Future<void> configureNotifications(double userId) async {
  final FcmtokenService _fcmTokenService = FcmtokenService();

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
  } else {
    print("Failed to retrieve FCM token.");
  }
}

