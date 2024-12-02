class EventScroll {
  final int eventId;
  final String eventImage;
  final String eventName;
  final String eventDate;
  String organiserName;
  String organiserImage;

  EventScroll({
    required this.eventId,
    required this.eventName,
    required this.eventImage,
    required this.eventDate,
    required this.organiserName,
    required this.organiserImage,
  });

  // Factory method to create an instance from JSON
  factory EventScroll.fromJson(Map<String, dynamic> json) {
    return EventScroll(
      eventId: json['id'],
      eventName: json['name'],
      eventImage: json['imagePath'] ?? '',
      eventDate: json['startDate'] ?? '',
      organiserName: '',
      organiserImage: '',
    );
  }

  @override
  String toString() {
    return 'EventScroll{eventId: $eventId, eventName: $eventName, eventImage: $eventImage,  eventDate: $eventDate, organiserName: $organiserName, organiserImage: $organiserImage,}';
  }
}
