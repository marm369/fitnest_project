import 'dart:convert';

import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../profile/screens/profile_user.dart';
import '../controllers/requests_controller.dart';
import '../models/participation_model.dart';

class RequestsPage extends StatelessWidget {
  final RequestsController requestsController = Get.put(RequestsController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Obx(() {
        if (requestsController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (requestsController.participations.isEmpty) {
          return const Center(
              child: Text(
                "No participations requests found.",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ));
        }
        return ListView.builder(
          itemCount: requestsController.participations.length,
          itemBuilder: (context, index) {
            final participation = requestsController.participations[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Colors.blue.shade50,
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileUser(
                          participantId: participation.participantId,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: participation.participantImage != null &&
                          participation.participantImage!.isNotEmpty
                          ? DecorationImage(
                        image: MemoryImage(
                          base64Decode(participation
                              .participantImage!), // Décodage Base64
                        ),
                        fit:
                        BoxFit.cover, // Maintient le ratio de l'image
                      )
                          : null,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ),
                title: Text(
                  participation.participantName ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("wants to join the event",
                        style: const TextStyle(color: Colors.black)),
                    Text(
                      participation.eventName ?? "",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.green),
                      onPressed: () {
                        // Action pour accepter la demande
                        _handleAcceptParticipation(participation);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        // Action pour refuser la demande
                        _handleRejectParticipation(participation);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  void _handleAcceptParticipation(ParticipationModel participation) {
    requestsController.acceptParticipation(
        participation.participantId, participation.eventId);
    requestsController.fetchAndSetParticipations();
  }

  void _handleRejectParticipation(ParticipationModel participation) {
    requestsController.cancelParticipation(
        participation.participantId, participation.eventId);
    requestsController.fetchAndSetParticipations();
  }
}