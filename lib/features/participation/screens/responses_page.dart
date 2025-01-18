import 'dart:convert';
import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/responses_controller.dart';

class ResponsesPage extends StatelessWidget {
  final ResponsesController responsesController =
  Get.put(ResponsesController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Obx(() {
        if (responsesController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (responsesController.participations.isEmpty) {
          return const Center(
            child: Text(
              "No participations responses found.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          );
        }
        return ListView.builder(
          itemCount: responsesController.participations.length,
          itemBuilder: (context, index) {
            final participation = responsesController.participations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  participation.status == "ACCEPTED"
                      ? "You are accepted to join the event: ${participation.eventName}."
                      : participation.status == "REFUSED"
                      ? "Unfortunately, your participation request for the event: ${participation.eventName} has been rejected."
                      : "Your participation request for the event: ${participation.eventName} is still pending.",
                  style: TextStyle(
                    fontSize: 16,
                    color: participation.status == "ACCEPTED"
                        ? Colors.green
                        : participation.status == "REFUSED"
                        ? Colors.red
                        : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}