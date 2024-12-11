import 'package:fitnest/features/notifs/models/fcmtoken_model.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../../events/models/event.dart';
import '../configs/notifications_configuration.dart';
import '../services/fcmToken_service.dart';

//when event is created a notification should be send to all users
Future<void> event_created(Event event )async {
  List<fcmtokenModel> fcmtokens = fetchAll() as List<fcmtokenModel>;
  for(fcmtokenModel fcmtoken in fcmtokens) {
    NotificationModel notif = new NotificationModel(
        recipient: fcmtoken.recipient,
        type: "EVENT_CREATED",
        content: "An event was created under the name of ${event.name} starting from ${event.startDate}",
        timestamp: DateTime.now(),
        token: fcmtoken.token);
    sendNotifications(notif, null);
  }
}

//TODO: REMINDER for events participants
//TODO: EVENT_CANCELED
//TODO: EVENT_MODIFIED
//TODO: EVENT_REGISTRATION
//TODO: PARTICIPATION_CONFIRMED
//TODO: PARTICIPATIN_REJECTED
