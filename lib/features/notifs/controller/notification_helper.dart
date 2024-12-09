import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotifications() async {

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,

    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> handleMessages(RemoteMessage message) async {
    if (message.notification != null) {
      _showNotification(message.notification!);
    }

    /*
    print("Notification received: ${message.notification?.title}");
    print("Notification body: ${message.notification?.body}");
    showToast(
        text: 'Notification received in foreground',
        state: ToastStates.SUCCESS);*/
  }

  void handleBackgroundNotifications() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleMessages(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessages(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        handleMessages(message);
      }
    });
  }

  Future<void> _showNotification(RemoteNotification notification) async {

    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: 'tlogo',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


}
