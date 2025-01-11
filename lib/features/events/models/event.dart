class SportCategory {
  final int id;
  final String name;
  final String iconName;
  final bool requiresRoute;

  SportCategory({
    required this.id,
    required this.name,
    required this.iconName,
    required this.requiresRoute,
  });

  factory SportCategory.fromJson(Map<String, dynamic> json) {
    return SportCategory(
      id: json['id'],
      name: json['name'],
      iconName: json['iconName'],
      requiresRoute: json['requiresRoute'],
    );
  }

  @override
  String toString() {
    return 'SportCategory{id: $id, name: $name,  iconName: $iconName, requiresRoute: $requiresRoute}';
  }
}

class Location {
  final String locationName;
  final double latitude;
  final double longitude;

  Location({
    required this.locationName,
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      locationName: json['locationName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  @override
  String toString() {
    return 'Location{locationName: $locationName, latitude: $latitude, longitude: $longitude}';
  }
}

class Route {
  final List<List<double>> coordinatesFromPath;

  Route({
    required this.coordinatesFromPath,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    var coordinatesList = (json['coordinatesFromPath'] as List)
        .map((coordinate) => List<double>.from(coordinate))
        .toList();
    return Route(
      coordinatesFromPath: coordinatesList,
    );
  }
}

class Event {
  final int id;
  final String name;
  final String description;
  final String cityName;
  final double latitude;
  final double longitude;
  final String startDate;
  final String endDate;
  final String sportCategoryName;
  final int sportCategoryId;
  final int maxParticipants;
  final int currentNumParticipants;
  final String imagePath;
  final Location? location;
  final Route? route;
  final SportCategory sportCategory;
  final String startTime;
  final int organizerId;

  // Constructor
  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.cityName,
      required this.latitude,
      required this.longitude,
      required this.startDate,
      required this.endDate,
      required this.sportCategoryName,
      required this.sportCategoryId,
      required this.maxParticipants,
      required this.currentNumParticipants,
      required this.imagePath,
      this.location,
      this.route,
      required this.sportCategory, // Add this to the constructor
      required this.startTime,
      required this.organizerId // Add this to the constructor
      });

  // JSON Deserialization
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        id: json['id'],
        name: json['name'] ?? 'Unnamed event',
        description: json['description'] ?? 'No description available',
        cityName: json['cityName'] ?? 'Unknown location',
        latitude: json['latitude'] ?? 0.0,
        longitude: json['longitude'] ?? 0.0,
        startDate: json['startDate'] ?? '',
        endDate: json['endDate'] ?? '',
        sportCategoryName: json['sportCategoryName'] ?? 'No category',
        sportCategoryId: json['sportCategoryId'] ?? 0,
        maxParticipants: json['maxParticipants'] ?? 0,
        currentNumParticipants: json['currentNumParticipants'] ?? 0,
        imagePath: json['imagePath'] ?? '',
        location: json['location'] != null
            ? Location.fromJson(json['location'])
            : null,
        route: json['route'] != null ? Route.fromJson(json['route']) : null,
        sportCategory: SportCategory.fromJson(json['sportCategory'] ?? ''),
        startTime: json['startTime'] ?? '',
        organizerId: json['organizerId'] ?? 0);
  }

  // toString Method to print all fields
  @override
  String toString() {
    return 'Event{id: $id, name: $name, description: $description, city: $cityName, latitude: $latitude, longitude: $longitude, startDate: $startDate, endDate: $endDate, sportCategoryName: $sportCategoryName, sportCategoryId: $sportCategoryId, maxParticipants: $maxParticipants, currentNumParticipants: $currentNumParticipants,location: $location, route: $route, sportCategory: $sportCategory, startTime: $startTime, organizerId: $organizerId}';
  }
}
