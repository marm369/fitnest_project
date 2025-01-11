import 'package:fitnest/features/participation/screens/requests_page.dart';
import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/participation_controller.dart';

class ParticipationScreen extends StatelessWidget {
  final ParticipationController controller = Get.put(ParticipationController());

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Participations'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: dark ? Colors.white : Colors.black,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => RequestsPage()),
          ),
        ],
      ),
    );
  }
}
