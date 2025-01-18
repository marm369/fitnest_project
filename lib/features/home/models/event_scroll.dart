class EventScroll {
  final int eventId;
  final String eventImage;
  final String eventName;
  final DateTime eventDate;
  String organizerName;
  String organizerImage;
  final organizerId;
  EventScroll({
    required this.eventId,
    required this.eventName,
    required this.eventImage,
    required this.eventDate,
    required this.organizerName,
    required this.organizerImage,
    required this.organizerId,
  });

  // Factory method to create an instance from JSON
  factory EventScroll.fromJson(Map<String, dynamic> json) {
    return EventScroll(
      eventId: json['id'] ?? 0,
      eventName: json['name'],
      eventImage: json['imagePath'] ?? '',
      eventDate: DateTime.parse(json['startDate'] ?? '2000-01-01'),
      organizerName: '',
      organizerImage: '',
      organizerId: json['organizerId'],
    );
  }

  @override
  String toString() {
    return 'EventScroll{eventId: $eventId, eventName: $eventName, eventImage: $eventImage,  eventDate: $eventDate, organiserName: $organizerName, organiserImage: $organizerImage,}';
  }
}