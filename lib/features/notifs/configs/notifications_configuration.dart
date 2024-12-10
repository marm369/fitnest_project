/*import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitnest/features/notifs/services/fcmToken_service.dart.dart';

Future<void> ConfigureNotifications() async {

  await FirebaseMessaging.instance.requestPermission();

  await initializeToken();
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
*/