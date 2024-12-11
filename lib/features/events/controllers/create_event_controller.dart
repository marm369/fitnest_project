import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/event/event_service.dart';
import '../../../data/services/map/geolocalisation_service.dart';
import '../../../utils/popups/loaders.dart';
import '../../maps/screens/city_search_screen.dart';
import '../../maps/screens/create_itineraire.dart';
import '../models/event.dart';

class EventController extends GetxController {
  final EventService eventService = EventService();
  final GeolocalisationService geoService = GeolocalisationService();
  // Text editing controllers
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationNameController = TextEditingController();

  var eventInfos = <Event>[].obs;

  final box = GetStorage();
  // Reactive variables
  final startDate = Rx<DateTime?>(null);
  final endDate = Rx<DateTime?>(null);
  final startTime = Rx<TimeOfDay?>(null);
  final eventImage = Rx<String?>(null);
  final participantCount = 1.obs;
  final selectedCategory = Rx<String?>(null);
  final routeCoordinates = RxList<List<double>>(); // Stores route points
  final latitude = RxDouble(0.0);
  final longitude = RxDouble(0.0);

  final ImagePicker _picker = ImagePicker();

  /// Select a date for either start or end.
  Future<void> selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      isStart ? startDate.value = picked : endDate.value = picked;
    }
  }

  /// Select a start time.
  Future<void> selectStartTime() async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      startTime.value = picked;
    }
  }

  /// Format a TimeOfDay object to a string.
  String formatTimeOfDay(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes:00';
  }

  /// Choose an image from the gallery.
  Future<void> chooseImage() async {
    // Utilisation de ImagePicker pour ouvrir la galerie
    final image = await _picker.pickImage(source: ImageSource.gallery);
    // Vérifier si une image a été sélectionnée
    if (image != null) {
      // Stocker le chemin de l'image sous forme de chaîne
      eventImage.value = image.path; // Stocke le chemin de l'image en String
    } else {
      eventImage.value = null; // Aucune image sélectionnée
    }
  }

  /// Open the map to select a location.
  Future<void> viewMap() async {
    final result = await Get.to(() => CitySearchMapScreen(
          placeName: locationNameController.text,
        ));

    if (result != null && result is Map<String, dynamic>) {
      if (result.containsKey('latitude') &&
          result.containsKey('longitude') &&
          result.containsKey('locationName')) {
        locationNameController.text = result['locationName'];
        latitude.value = result['latitude'];
        longitude.value = result['longitude'];
      } else {
        Loaders.errorSnackBar(
            title: "Error", message: "Some location information is missing");
      }
    }
  }

  void incrementParticipantCount() {
    participantCount.value++;
  }

  void decrementParticipantCount() {
    if (participantCount.value > 1) {
      participantCount.value--;
    } else {
      Loaders.warningSnackBar(
          title: "Warning",
          message: "The number of participants cannot be less than 1.");
    }
  }

  /// Submit the event form.
  Future<void> submitForm(String id) async {
    int? routeId;
    if (routeCoordinates.isNotEmpty) {
      routeId = await geoService.createRoute(routeCoordinates);
    }

    int? locationId;
    if (latitude.value != 0.0 && longitude.value != 0.0) {
      locationId = await geoService.createLocation(
          locationNameController.text, latitude.value, longitude.value);
    }

    /*if (locationId == null || routeId == null) {
      Loaders.errorSnackBar(
          title: "Error", message: "Please provide a route or a location.");
      return;
    }*/

    Map<String, dynamic>? eventRequestBody =
        await _buildEventRequestBody(routeId, locationId, id);
    if (eventRequestBody == null) return;

    await eventService.createEvent(eventRequestBody);
  }

  /// Open a map to create a route.
  Future<void> createRouteInMap() async {
    final result = await Get.to(() => CreationItineraire());

    if (result != null && result is List<List<double>>) {
      print(result); // Affiche les coordonnées
      routeCoordinates.value =
          result; // Mise à jour des coordonnées dans RxList
      Loaders.successSnackBar(
          title: "Success", message: "Route coordinates imported!");
    } else {
      Loaders.warningSnackBar(
          title: "Warning", message: "No route has been selected.");
    }
  }

  /// Build the event request body.
  Future<Map<String, dynamic>?> _buildEventRequestBody(
      int? routeId, int? locationId, String id) async {
    try {
      final base64Image = eventImage.value != null
          ? base64Encode(await File(eventImage.value!)
              .readAsBytes()) // Créer un objet File à partir du chemin
          : null;

      if (base64Image == null) {
        Loaders.errorSnackBar(title: "Error", message: "Select an Image.");
        return null;
      }

      return {
        "name": nameController.text,
        "description": descriptionController.text,
        "startDate": startDate.value?.toIso8601String().split('T')[0],
        "endDate": endDate.value?.toIso8601String().split('T')[0],
        "startTime": startTime.value != null
            ? formatTimeOfDay(startTime.value!)
            : "07:00:00",
        "maxParticipants": participantCount.value,
        "currentNumParticipants": 0,
        "imagePath": base64Image,
        "sportCategory": {"id": id},
        "routeId": routeId,
        "locationId": locationId,
        "organizerId": box.read('user_id')
      };
    } catch (e) {
      Loaders.errorSnackBar(
          title: "Error", message: "Error while preparing the data: $e");
    }
    return null;
  }
}
