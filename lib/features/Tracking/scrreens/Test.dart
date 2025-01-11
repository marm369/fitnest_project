import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  final int organizerId; // Ajout de l'argument organizerId

  MapPage({required this.organizerId}); // Constructeur mis à jour

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController _mapController;
  LatLng? _initialLocation; // Position initiale (marqueur vert)
  LatLng _currentLocation = LatLng(0.0, 0.0); // Position actuelle (marqueur rouge)
  bool _isLocationServiceEnabled = false;
  bool _isPermissionGranted = false;
  List<LatLng> _routePoints = []; // Points de la route
  double _currentSpeed = 0.0; // Vitesse en m/s

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initLocationService();
    print("Organizer ID: ${widget.organizerId}"); // Utilisation de organizerId
  }

  Future<void> _initLocationService() async {
    _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!_isLocationServiceEnabled) {
      _isLocationServiceEnabled = await Geolocator.openLocationSettings();
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      _isPermissionGranted = true;
      _startLocationTracking();
    } else {
      print("Permission non accordée");
    }
  }

  void _startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Calculer la distance entre l'ancienne et la nouvelle position
      double distance = _routePoints.isEmpty
          ? 0
          : Geolocator.distanceBetween(
        _currentLocation.latitude,
        _currentLocation.longitude,
        newLocation.latitude,
        newLocation.longitude,
      );

      // Ignorer les positions incohérentes (trop éloignées)
      if (distance > 500) {
        print("Position incohérente ignorée : $newLocation");
        return;
      }

      if (_initialLocation == null) {
        _initialLocation = newLocation;
      }

      setState(() {
        _currentLocation = newLocation;
        _routePoints.add(_currentLocation);
        _currentSpeed = position.speed;
      });

      // Vibration
      Vibrate.canVibrate.then((bool canVibrate) {
        if (canVibrate) {
          Vibrate.feedback(FeedbackType.success);
        }
      });
    });
  }

  bool _isNightMode() {
    int hour = DateTime.now().hour;
    return hour >= 18 || hour <= 6;
  }

  @override
  Widget build(BuildContext context) {
    double totalDistance = 0;
    if (_routePoints.length > 1) {
      for (int i = 0; i < _routePoints.length - 1; i++) {
        totalDistance += Geolocator.distanceBetween(
          _routePoints[i].latitude,
          _routePoints[i].longitude,
          _routePoints[i + 1].latitude,
          _routePoints[i + 1].longitude,
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Suivi de la position'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentLocation,
              zoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: _isNightMode()
                    ? "https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png"
                    : "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _routePoints,
                    color: Colors.blue,
                    strokeWidth: 4.0,
                    isDotted: true, // Ligne pointillée
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (_initialLocation != null)
                    Marker(
                      width: 60.0,
                      height: 60.0,
                      point: _initialLocation!,
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.green,
                        size: 40.0,
                      ),
                    ),
                  Marker(
                    width: 60.0,
                    height: 60.0,
                    point: _currentLocation,
                    builder: (ctx) => Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Infos en Temps Réel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('Coordonnées : ${_currentLocation.latitude.toStringAsFixed(5)}, ${_currentLocation.longitude.toStringAsFixed(5)}'),
                    Text('Distance Parcourue : ${totalDistance.toStringAsFixed(2)} m'),
                    Text('Vitesse Actuelle : ${(_currentSpeed * 3.6).toStringAsFixed(2)} km/h'),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 20,
            child: FloatingActionButton(
              onPressed: () {
                if (_routePoints.isNotEmpty) {
                  _mapController.move(_routePoints.last, 15.0);
                }
              },
              child: Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
