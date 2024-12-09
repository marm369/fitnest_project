import '../../../data/services/event/event_service.dart';
import '../models/event.dart';

class EventControllerManagement {
  final EventService eventService;

  List<Event> events = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedDateFilter;
  String? selectedPartOfDay;
  String? selectedDistance;
  EventControllerManagement({required this.eventService});

  Future<void> getEvents({
    String? category,
    String? dateFilter,
    String? partDay,
    String? distance,
    double? latitude,
    double? longitude,
  }) async {
    try {
      isLoading = true;

      // Fetch events using the event service.
      events = await eventService.fetchEvents(
          category: category ?? selectedCategory,
          dateFilter: dateFilter ?? selectedDateFilter,
          partDay: partDay ?? selectedPartOfDay,
          distance: distance ?? selectedDistance,
          latitude: latitude,
          longitude: longitude);
    } catch (e) {
      print('Error fetching events: $e');
      events = [];
    } finally {
      isLoading = false;
    }
  }

  /// Sets filters for the event search.
  void setFilters({
    String? category,
    String? dateFilter,
    String? partDay,
  }) {
    selectedCategory = category;
    selectedDateFilter = dateFilter;
    selectedPartOfDay = partDay;
  }
}
