import 'dart:convert';


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';

   final _firebaseMessaging =  FirebaseMessaging.instance;
   Future<void> initializeToken(double userId) async {
     try {
       await _firebaseMessaging.requestPermission();

       String? deviceToken = await _firebaseMessaging.getToken();

       if (deviceToken != null) {
         print("===================Device FirebaseMessaging Token====================");
         print(deviceToken);
         print("===================Device FirebaseMessaging Token====================");

         await insertTokenIntoDatabase(deviceToken, userId );
       }
     } catch (e) {
       print("Error retrieving FCM token: $e");
     }
   }

   Future<void> insertTokenIntoDatabase(String token, double userId) async {
     String url = "$GatewayUrl/api/fcm-token/associate";

     final requestBody = {'token': token, 'userId': userId};

     final response = await http.post(
       Uri.parse('$GatewayUrl/api/events/createEvent'),
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(requestBody),
     );

     if (response.statusCode == 200) print("token was set seccessfuly");
   }