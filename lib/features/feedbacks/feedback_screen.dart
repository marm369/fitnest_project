import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'feedback_controller.dart';

class FeedbackDialog extends StatelessWidget {
  final int userId;
  final List<Map<String, dynamic>> events;

  FeedbackDialog({
    required this.userId,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final FeedbackController controller = Get.put(FeedbackController());
    final RxInt currentEventIndex = 0.obs;

    void showNextEventOrClose() {
      if (currentEventIndex.value < events.length - 1) {
        currentEventIndex.value++;
      } else {
        Navigator.of(context).pop();
      }
    }

    return Obx(() {
      if (currentEventIndex.value >= events.length) {
        return SizedBox.shrink();
      }

      final currentEvent = events[currentEventIndex.value];
      final String resortName = currentEvent['title'] ?? 'Unknown Event';
      final String location = currentEvent['location'] ?? '';
      final String imageUrl = currentEvent['image'] ?? 'https://via.placeholder.com/150';
      final String eventId = currentEvent['idEvent'].toString();

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Obx(() => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context, controller, resortName, location, imageUrl),
                if (!controller.isSubmitted.value) ...[
                  _buildContent(controller, eventId),
                  _buildFooter(controller, userId, eventId, showNextEventOrClose),
                ] else
                  _buildThankYouContent(),
              ],
            ),
          ),
        )),
      );
    });
  }

  Widget _buildHeader(BuildContext context, FeedbackController controller, String resortName, String location, String imageUrl) {
    return Stack(
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.memory(
                base64Decode(imageUrl),
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    resortName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          right: 16,
          top: 16,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(FeedbackController controller, String eventId) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How was your experience?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () => controller.updateRating(index + 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < controller.rating.value
                        ? Icons.star
                        : Icons.star_border,
                    size: 40,
                    color: Colors.orange,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 24),
          Text(
            'More details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          TextField(
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Let others know about your experiences with this event",
              hintStyle: TextStyle(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            onChanged: (value) => controller.updateComment(value),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(FeedbackController controller,int userId, String eventId, VoidCallback onSubmit) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                controller.updateEventSelection(eventId);
                await controller.submitFeedback(userId);
                onSubmit();
              },
              child: controller.isLoading.value
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThankYouContent() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Image.asset(
            'assets/images/thanks.jpg',
            height: 120,
          ),
          SizedBox(height: 16),
          Text(
            'Thanks for your\nfeedback 😎',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
