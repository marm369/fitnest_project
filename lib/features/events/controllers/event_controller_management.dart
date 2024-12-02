import '../../../data/services/event/event_service.dart';
import '../models/event.dart';

class EventControllerManagement {
  final EventService eventService;

  List<Event> events = [];
  bool isLoading = false;
  String? selectedCategory;
  String? selectedDateFilter;
  String? selectedPartOfDay;

  EventControllerManagement({required this.eventService});

  Future<void> getEvents({
    String? category,
    String? dateFilter,
    String? partDay,
  }) async {
    try {
      isLoading = true;

      events = await eventService.fetchEvents(
        category: category ?? selectedCategory,
        dateFilter: dateFilter ?? selectedDateFilter,
        partDay: partDay ?? selectedPartOfDay,
      );
    } catch (e) {
      print('Error fetching events: $e');
      events = [];
    } finally {
      isLoading = false;
    }
  }

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
