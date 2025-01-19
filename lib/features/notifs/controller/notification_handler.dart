import 'package:fitnest/features/notifs/models/fcmtoken_model.dart';
import 'package:fitnest/features/notifs/models/notif_model.dart';
import '../../events/models/event.dart';
import '../../participation/models/participation_model.dart';
import '../configs/notifications_configuration.dart';
import '../services/fcmToken_service.dart';

class NotifHandler {

  final FcmtokenService _fcmTokenService;

  NotifHandler(this._fcmTokenService);

  Future<void> notifyEventCreation(Event event) async {
    List<fcmtokenModel> fcmtokens = await _fcmTokenService.fetchAll();
    for (fcmtokenModel fcmtoken in fcmtokens) {
      NotificationModel notif = NotificationModel(
          recipient: fcmtoken.recipient,
          type: "FitNest",
          content: "The event ${event.name} was just created, it is located at ${event.cityName} starting from ${event.startDate}",
          timestamp: DateTime.now(),
          token: fcmtoken.token);
      await sendNotifications(notif, null);
      print('Notification sent: $notif to token ${fcmtoken.token}');
    }
  }

  Future<void> notifyEventCancelation(Event event) async {
    List<fcmtokenModel?> tokens = await _fcmTokenService.fetchExistingParticipantTokens(event.id);
    for (fcmtokenModel? token in tokens) {
      if (token != null) {
        NotificationModel notif = NotificationModel(
            recipient: token.recipient,
            type: "FitNest",
            content: "The event ${event.name} was just canceled",
            timestamp: DateTime.now(),
            token: token.token);
        await sendNotifications(notif, null);
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
        await sendNotifications(notif, null);
        print('Notification sent: $notif to token ${token.token}');
      }
    }
  }

  Future<void> notifyRegisterEvent(ParticipationModel participant, Event event) async {
    fcmtokenModel? token = await _fcmTokenService.fetchToken(event.organizerId);

    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: participant.id,
        type: "NEW_REGISTRATION",
        content: "${participant.participantName} has registered for your event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif, null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

  Future<void> notifyConfirmedParticipation(ParticipationModel participant, Event event) async {
    fcmtokenModel? token = await _fcmTokenService.fetchToken(participant.id);

    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: participant.id,
        type: "NEW_REGISTRATION",
        content: "your registered was confirmed for the event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif, null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

  Future<void> notifyRejectedParticipation(ParticipationModel participant, Event event) async {
    fcmtokenModel? token = await _fcmTokenService.fetchToken(participant.id);

    if (token != null) {
      NotificationModel notif = NotificationModel(
        recipient: participant.id,
        type: "NEW_REGISTRATION",
        content: "your registration was rejected for the event ${event.name}.",
        timestamp: DateTime.now(),
        token: token.token,
      );
      await sendNotifications(notif, null);
      print('Notification sent: \$notif to token \${token.token}');
    }
  }

}

//TODO: REMINDER for events participants
