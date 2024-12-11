import 'package:firebase_core/firebase_core.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnest/features/notifs/services/fcmToken_service.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

Future<String?> getAccessToken() async {
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "fitnest-6980d",
    "private_key_id": "cedbed82d6bd700808106bc3f343f622b0aabcce",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbdzcyqKSOWh/L\n6OzMVC6cV8MM8/F748s4few4wNFJXn/i7epgoOS5H1QyhBe0M9LDTlYBUOnTEgSr\nqVQbbPmFIIE6FT5okfExnOlTeRNm2cgHy6FxeG2KB8LAow24mA+f4lCP84NSpvKG\n5ETbqoAUdHpNh5I8+mrXudJmhw8dE2OInWUKVFVATQckXDGWeVmDdmUJuP8sUdv7\ntio2O5ejUszn7VVllPsJa73khBa313bvXHgmR71O5Quz09KsiNseUYFSrTTATDCQ\nld3Os6RfJqtFLvMEg5JQ21SmbNZv5Er3l6QSGFt5aHJeBhCoamiP/LoEaLSO/RNd\nuXRfGI4fAgMBAAECggEAFOqJwjQ8aqzANwjd+KNVReU/W66sJyiQp7OoncgSqjFt\ncs1F9yueYN5RgfcA41XFEoQWwk1Z25nuBAZBU9PQ/BUa+9QmfITcPeQ8gI4bgUPk\nQonvuwbFOdB/iSiBGES1yIEjOHT24Ru0JZL/1Qes6UYomdb/4vvizuiQ2uCoWhbf\nqtO3aJ03HH4sl3GUSbqdgQ8IF6nPRziYg6YMXIwBoJeWGR8bdRCZ/wATHKPAQCAS\n3ypX2OFFKYYqD1jDReOzRSzC29pmsl0hyCpwzFdYWRdwnVpDbi7EO3oGPT1dzCDM\nlkg+V/dDJ4VRNuYnPiyjbmCgodJGNjYhtLBSKSwr8QKBgQD+3MQ+6sUg80zdGKbn\nQT3DC2vYcLvYg00nR5YJuiS+BX+8KHqDM4Wmr5LVoOJ5Rr9QhkYm1ew4P8O3Fi04\n3MT18ggWqJf1MhpDvAndKopssyryB+FX+hyGSm7urWlDOjP2k8VwdslyzHiOZQy7\nyi1snhcLrRUm3TWo7TsU8M98IwKBgQDccgA9eM1Eygm16AsLaAymI5Zt1FdIOghn\nza2HavEith7clZfZUfHbnzFu1WzJy0AxlwYgp3LMV7QUCqPzymWpTBc/hY25qb6q\ndhsBQ9Zlo/VsexMLkg8S0Z9ll8+P3pwNmnZy4X4pPNyDz1ucVa1Nd0OUgFuA4wfE\nfliMdFZ31QKBgQCSIHJEwMcWBWnkuuW3YijPVBUZnEmX8nCiPOFB4oB+kxiSAYN9\nBmVzFOfTpNM1ReMbgGFoku9FsQm+R/DV0X78pTEODMxTwc5dV8swC9wiRvgwnWQO\n1VDVjofcQYFBEnYIwuFJglIuiB33RujuIxW4WUxNXYfrKJpDqQFfGFNekQKBgC43\niG1a4k5FvXtxxr8BdYVveJ5WImZ2JET/Dh6SATQx0o6Unl1lnLtayNZf0IsOHctH\nynUWJi9JQ+vfvzfheybfWRBsQ6ZlPCAo2siNHGn60f2IYBnQ6XAcmrqF9XJITZdc\nhvDW7chfhivsUVyZadgP5Q9BSe3fq0U65/2qdmZxAoGAPawq1wdnz6kdHIQs/wve\nLLPxyzzT81QBNlAvcgAEl1AOFdC9OoQ2HQonZE8LB3+4+htM0l7OMpPN33OS0BQa\nRBNhMf5hzIMKO9nShm0rnofzeIlMVV3R/nCFYDZ4lrYPSlCkJuhwoJs3DYdYTghh\nk0rN1m4KA54zC1hW9C+RKss=\n-----END PRIVATE KEY-----\n",
    "client_email": "fitnestapp@fitnest-6980d.iam.gserviceaccount.com",
    "client_id": "111665718282322466581",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/fitnestapp%40fitnest-6980d.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  try {
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes);

    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);

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

Future<void> ConfigureNotifications(double userid) async {

  await FirebaseMessaging.instance.requestPermission();

  await initializeToken(userid);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAiqgGAGkAAD2RazL_g6wG8WwMlN07YuoE",
        appId: "1:1068465758439:android:2f37a8d3e960370e360242",
        messagingSenderId: "1068465758439",
        projectId: "fitnest-6980d",
      )
  );
}