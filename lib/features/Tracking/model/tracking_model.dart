class Tracking {
  final int organizedId;
  final int eventId;
  final double latitude;
  final double longitude;
  final String lastUpdated;

  Tracking({
    required this.organizedId,
    required this.eventId,
    required this.latitude,
    required this.longitude,
    required this.lastUpdated,
  });

  // Convertir un objet Tracking en une Map pour l'envoi via HTTP
  Map<String, dynamic> toMap() {
    return {
      'participantId': organizedId,
      'eventId': eventId,
      'latitude': latitude,
      'longitude': longitude,
      'lastUpdated': lastUpdated,
    };
  }

  // Convertir la réponse JSON en un objet Tracking
  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
     organizedId: json['organizerId'],
      eventId: json['eventId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      lastUpdated: json['lastUpdated'],
    );
  }
}
