
import 'package:fitnest/features/maps/Models/point.dart';

class RouteModel {
  final List<Point> points;

  RouteModel({required this.points});

  factory RouteModel.fromJson(List<dynamic> json) {
    List<Point> points = json.map((pointJson) => Point(
      lat: (pointJson['lat'] as num).toDouble(),
      lng: (pointJson['lng'] as num).toDouble(),
    )).toList();
    return RouteModel(points: points);
  }

  List<Map<String, dynamic>> toJson() {
    return points.map((point) => {
      'lat': point.lat,
      'lng': point.lng,
    }).toList();
  }
}
