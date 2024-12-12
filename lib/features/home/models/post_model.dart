import '../../events/models/event.dart';

class PostModel {
  final int id;
  final String name;
  final String description;
  final int organizerId;
  final String organizerFirstName;
  final String organizerLastName;
  final String organizerImage;
  final String cityName;
  final DateTime startDate;
  final String startTime;
  final int maxParticipants;
  final int currentNumParticipants;
  final String imagePath;
  final String sportCategoryName;
  final String sportCategoryIcon;

  PostModel({
    required this.id,
    required this.name,
    required this.description,
    required this.organizerId,
    required this.organizerFirstName,
    required this.organizerLastName,
    required this.organizerImage,
    required this.cityName,
    required this.startDate,
    required this.startTime,
    required this.maxParticipants,
    required this.currentNumParticipants,
    required this.imagePath,
    required this.sportCategoryName,
    required this.sportCategoryIcon,
  });

  // Constructeur `fromEvent` avec le paramètre `user`
  factory PostModel.fromEvent(Event event,
      {required Map<String, dynamic> user}) {
    return PostModel(
      id: event.id,
      name: event.name,
      description: event.description,
      organizerId: user['id'],
      organizerFirstName: user['firstName'] ?? 'Inconnu',
      organizerLastName: user['lastName'] ?? 'Inconnu',
      organizerImage: user['profilePicture'] ?? '',
      cityName: event.cityName,
      startDate: DateTime.parse(event.startDate),
      startTime: event.startTime,
      maxParticipants: event.maxParticipants,
      currentNumParticipants: event.currentNumParticipants,
      imagePath: event.imagePath,
      sportCategoryName: event.sportCategory.name,
      sportCategoryIcon: event.sportCategory.iconName,
    );
  }
}
