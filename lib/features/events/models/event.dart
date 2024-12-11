import 'dart:convert';

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
  final Location location;
  final Route route;
  final String startDate;
  final String endDate;
  final String sportCategoryName;
  final int sportCategoryId;
  final int maxParticipants;
  final int currentNumParticipants;
  final String imagePath;
  final SportCategory sportCategory;
  final String startTime;
  final int organizerId;

  Event(
      {required this.id,
      required this.name,
      required this.description,
      required this.cityName,
      required this.latitude,
      required this.longitude,
      required this.startDate,
      required this.endDate,
        required this.location,
        required this.route,
      required this.sportCategoryName,
      required this.sportCategoryId,
      required this.maxParticipants,
      required this.currentNumParticipants,
      required this.imagePath,
      required this.sportCategory, // Add this to the constructor
        required this.startTime,
      required this.organizerId // Add this to the constructor
      });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'] ?? 'Unnamed event',
      description: json['description'] ?? 'No description available',
      cityName: json['location']?['locationName'] ?? 'Unknown location',
      latitude: json['location']?['latitude'] ?? 0.0,
      longitude: json['location']?['longitude'] ?? 0.0,
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      sportCategoryName: json['sportCategory']?['sportCategoryName'] ?? 'No category',
      sportCategoryId: json['sportCategory']?['sportCategoryId'] ?? 0,
      maxParticipants: json['maxParticipants'] ?? 0,
      currentNumParticipants: json['currentNumParticipants'] ?? 0,
      location: Location.fromJson(json['location'] ?? {}),
      route: Route.fromJson(json['route'] ?? {'coordinatesFromPath': []}),
      imagePath: json['imagePath'] ?? '',
      sportCategory: json['sportCategory'] != null
          ? SportCategory.fromJson(json['sportCategory'])
          : SportCategory(
        id: 0,
        name: 'No category',
        iconName: '',
        requiresRoute: false,
      ),
      startTime: json['startTime'] ?? '00:00:00',
      organizerId: json['idCoordinator'],
    );
  }

}
