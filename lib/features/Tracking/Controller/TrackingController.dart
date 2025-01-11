import 'dart:async';

import '../model/tracking_model.dart';
import '../service/tracking_service.dart';

/*
class TrackingController {
  final TrackingService locationService = TrackingService();

  Future<Tracking> getLocation(int eventId) async {
    return await locationService.fetchEventLocation(eventId);
  }

  Stream<Tracking> trackLocation(int eventId, {Duration interval = const Duration(seconds: 5)}) async* {
    while (true) {
      yield await getLocation(eventId);
      await Future.delayed(interval);
    }
  }
}
*/