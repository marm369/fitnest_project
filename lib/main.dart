import 'package:fitnest/app.dart';
import 'package:fitnest/data/services/participation/participation_service.dart';
import 'package:fitnest/features/notifs/services/fcmToken_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'features/events/models/event.dart' as EventModel;
import 'features/notifs/configs/notifications_configuration.dart';
import 'features/notifs/controller/notification_handler.dart';
import 'features/notifs/screens/display_notifs.dart';

// Example event you can use to test notify_event_creation
EventModel.Event testEvent = EventModel.Event(
  id: 1,
  name: "Test Event",
  description: "A test event for notification.",
  cityName: "Sample City",
  latitude: 37.7749,
  longitude: -122.4194,
  startDate: "2025-01-13",
  endDate: "2025-01-14",
  location: EventModel.Location(locationName: "Test Location", latitude: 37.7749, longitude: -122.4194),
  route: EventModel.Route(coordinatesFromPath: []),
  sportCategoryName: "Soccer",
  sportCategoryId: 1,
  maxParticipants: 20,
  currentNumParticipants: 5,
  imagePath: "test_image_path",
  sportCategory: EventModel.SportCategory(id: 1, name: "Soccer", iconName: "soccer_icon", requiresRoute: true),
  startTime: "09:00",
  organizerId: 123,
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Initialize notifHandler

  final storage = GetStorage();
  bool isFirstTime = storage.read('isFirstTime') ?? true;
  runApp(App(isFirstTime: isFirstTime));
  //runApp(MyApp1(notifHandler));
}

class MyApp1 extends StatelessWidget {
  NotifHandler notifHandler ;
  MyApp1(this.notifHandler);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  HomeScreen(notifHandler),
      //home: NotifScreen(userId: 1, eventId: 1),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final NotifHandler notifHandler;  // Add this as a parameter to the constructor

  // Add the constructor to receive the NotifHandler instance
  HomeScreen( this.notifHandler);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Test the event creation notification logic
            await notifHandler.notifyEventCreation(testEvent);  // This will call the function to send notifications
            print('Test Event creation notification sent!');
          },
          child: const Text('Test Event Creation Notification'),
        ),
      ),
    );
  }
}
