import 'package:fitnest/data/services/event/event_service.dart';
import 'package:fitnest/data/services/profile/user_service.dart';
import 'package:fitnest/features/notifs/models/fcmtoken_model.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import 'package:fitnest/features/profile/models/user_model.dart';
import '../../events/models/event.dart';
import '../../participation/models/participation_model.dart';
import '../configs/notifications_configuration.dart';
import '../services/fcmToken_service.dart';

class NotifHandler {

  final FcmtokenService _fcmTokenService;
  final EventService eventService = EventService();
  final UserService userService = UserService();

  NotifHandler(this._fcmTokenService);

  Future<void> notifyEventCreation(Event event) async {
    List<fcmtokenModel> fcmtokens = await _fcmTokenService.fetchAll();
    for (fcmtokenModel fcmtoken in fcmtokens) {
      NotificationModel notif = NotificationModel(
          recipient: fcmtoken.recipient,
          type: "EVENT_CREATED",
          content: "The event ${event.name} was just created, starting at ${event.startDate} and located in ${event.location} ",
          timestamp: DateTime.now(),
          token: fcmtoken.token);
      await sendNotifications(notif,event.id, null);
      print('Notification sent: $notif to token ${fcmtoken.token}');
    }
  }

  Future<void> notifyEventCancelation(Event event) async {
    List<fcmtokenModel?> tokens = await _fcmTokenService.fetchExistingParticipantTokens(event.id);
    for (fcmtokenModel? token in tokens) {
      if (token != null) {
        NotificationModel notif = NotificationModel(
            recipient: token.recipient,
            type: "EVENT_CANCELED",
            content: "The event ${event.name} was just canceled",
            timestamp: DateTime.now(),
            token: token.token);
        await sendNotifications(notif,event.id,  null);
        print('Notification sent: $notif to token ${token.token}');
      }
    }
  }

  Future<void> notifyEventUpdate(Event event) async {
    List<fcmtokenModel?> tokens = await _fcmTokenService.fetchExistingParticipantTokens(event.id);
    for (fcmtokenModel? token in tokens) {
      if (token != null) {
        NotificationModel notif = NotificationModel(
            recipient: token.recipient,
            type: "EVENT_UPDATED",
            content: "The event ${event.name} was just updated. Click to know more.",
            timestamp: DateTime.now(),
            token: token.token);
        await sendNotifications(notif,event.id,  null);
        print('Notification sent: $notif to token ${token.token}');
      }
    }
  }

  Future<void> notifyRegisterEvent(int userid, int eventid) async {
    Event event = await eventService.getEventById(eventid);
    UserModel user = await userService.fetchProfileData(userid);

    fcmtokenModel? token = await _fcmTokenService.fetchToken(event.organizerId);
    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: event.id,
        type: "NEW_REGISTRATION",
        content: "${user.firstName } ${user.lastName} has registered for your event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif,event.id,null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

  Future<void> notifyConfirmedParticipation(int participantid, int eventid) async {
    Event event = await eventService.getEventById(eventid);
    fcmtokenModel? token = await _fcmTokenService.fetchToken(participantid);

    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: participantid,
        type: "PARTICIPATION_CONFIRMED",
        content: "your registeration was confirmed for the event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif, event.id, null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

  Future<void> notifyRejectedParticipation(int participantid, int eventid) async {
    Event event = await eventService.getEventById(eventid);
    fcmtokenModel? token = await _fcmTokenService.fetchToken(participantid);

    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: participantid,
        type: "PARTICIPATION_DECLINED",
        content: "your registration was rejected for the event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif,event.id,null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

}

//TODO: REMINDER for events participants
