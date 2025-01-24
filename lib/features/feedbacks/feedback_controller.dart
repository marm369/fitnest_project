import 'package:get/get.dart';
import 'feedback_service.dart';

class FeedbackController extends GetxController {
  final FeedbackService _feedbackService = FeedbackService();
  final RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedEventId = ''.obs;
  final RxDouble rating = 0.0.obs;
  final RxString comment = ''.obs;
  final RxBool isSubmitted = false.obs;

  Future<void> loadEvents(int userId) async {
    isLoading.value = true;
    try {
      final fetchedEvents = await _feedbackService.fetchEventsByUserId(userId);
      events.value = fetchedEvents;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load events: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void updateEventSelection(String eventId) {
    selectedEventId.value = eventId;
  }

  void updateRating(double newRating) {
    rating.value = newRating;
  }

  void updateComment(String newComment) {
    comment.value = newComment;
  }

  Future<void> submitFeedback(int userId) async {
    if (selectedEventId.isEmpty) {
      Get.snackbar('Error', 'Please select an event');
      return;
    }

    if (rating.value == 0) {
      Get.snackbar('Error', 'Please provide a rating');
      return;
    }

    isLoading.value = true;
    try {
      final feedbackData = {
        'participationDTO': {
          'userId': userId,
          'eventId': selectedEventId.value
        },
        'rating': rating.value.toInt(), // Convert to integer
        'comment': comment.value,
      };

      await _feedbackService.submitFeedback(feedbackData);
      isSubmitted.value = true;

      // Close dialog after submission
      Future.delayed(Duration(seconds: 2), () => Get.back());
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit feedback: $e');
    } finally {
      isLoading.value = false;
    }
  }

}
