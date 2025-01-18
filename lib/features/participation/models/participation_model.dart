import '../../events/models/event.dart';
import '../../profile/models/user_model.dart';

class ParticipationModel {
  final int id;
  final int eventId;
  final int organizerId;
  final int participantId;
  final String? participantImage;
  final String? participantName;
  final String? status;
  final String eventName;

  ParticipationModel(
      {required this.id,
        required this.eventId,
        required this.organizerId,
        required this.participantId,
        this.participantImage,
        this.participantName,
        required this.eventName,
        required this.status});

  // Constructeur statique pour créer une instance depuis les données
  factory ParticipationModel.fromParticipation(
      Map<String, dynamic> participation, Event event, UserModel user) {
    return ParticipationModel(
      id: participation['id'],
      eventId: event.id,
      organizerId: event.organizerId,
      participantId: user.id,
      participantImage: user.profilePicture ?? '',
      participantName: (user.firstName ?? '') + ' ' + (user.lastName ?? ''),
      eventName: event.name ?? '',
      status: participation['status_participation'],
    );
  }
}