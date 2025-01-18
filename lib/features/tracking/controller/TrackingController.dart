import 'dart:async';

import 'package:fitnest/features/tracking/model/tracking_model.dart';
import 'package:fitnest/features/tracking/service/tracking_service.dart';


class TrackingController {
  final TrackingService _locationService = TrackingService();

  Future<Tracking> getLocation(int eventId) async {
    return await _locationService.fetchEventLocation(eventId);
  }

  Stream<Tracking> trackLocation(int eventId, {Duration interval = const Duration(seconds: 5)}) async* {
    while (true) {
      yield await getLocation(eventId);
      await Future.delayed(interval);
    }
  }
}
