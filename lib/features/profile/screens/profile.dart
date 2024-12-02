import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../events/controllers/create_event_controller.dart';
import '../../events/controllers/event_user_controller.dart';
import '../../events/models/event.dart';
import '../../events/screens/detail_event.dart';
import '../controllers/profile_controller.dart';
import 'settings.dart';

class ProfileScreen extends StatelessWidget {
  final EventUserController eventController = EventUserController();
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    final userProfile = controller.userProfile.value!;
    final futureEvents = eventController.getEventsByUser(userProfile.id);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text(userProfile.firstName + ' ' + userProfile.lastName),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            _buildProfileHeader(),
            SizedBox(height: MySizes.standardSpace),
            _buildEventsSection(futureEvents, context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/user2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/user2.jpg'),
              ),
              SizedBox(height: MySizes.standardSpace),
              Text(
                "minou",
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: MySizes.fontSizeLg),
              ),
              SizedBox(height: MySizes.standardSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStat("Following", "0"),
                  _buildStat("Followers", "0"),
                  _buildStat("Events", "2"),
                ],
              ),
              SizedBox(height: MySizes.standardSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary,
                      minimumSize: Size(120, 30),
                    ),
                    child: Text("Follow"),
                  ),
                  SizedBox(width: MySizes.spaceBtwItems),
                  OutlinedButton(
                    onPressed: () {},
                    child: Icon(Icons.email),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEventsSection(
      Future<List<Event>> futureEvents, BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Événements organisés par vous",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          FutureBuilder<List<Event>>(
            future: futureEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Erreur : ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text("Vous n'avez organisé aucun événement."),
                );
              } else {
                final events = snapshot.data!;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: events.map((event) {
                      return GestureDetector(
                        onTap: () => _showEventDetails(context, event),
                        child: Container(
                          width: 200,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                minHeight: 100,
                                maxHeight: 150,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: event.imagePath != null
                                        ? Image.memory(
                                            base64Decode(event.imagePath!),
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            height: 60,
                                            color: Colors.grey.shade300,
                                            child: const Icon(Icons.event,
                                                size: 30, color: Colors.grey),
                                          ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          event.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        if (event.location != null)
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  color: Colors.black,
                                                  size: MySizes.iconSm),
                                              SizedBox(
                                                  width: MySizes.spaceBtwItems /
                                                      2),
                                              Text(
                                                "${event.location!.locationName}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        MySizes.fontSizeSm),
                                              ),
                                            ],
                                          )
                                        else
                                          Row(
                                            children: [
                                              Icon(Icons.location_on,
                                                  color: Colors.black,
                                                  size: MySizes.iconSm),
                                              SizedBox(
                                                  width: MySizes.spaceBtwItems /
                                                      2),
                                              Text(
                                                "Loc: Not available",
                                                style: TextStyle(
                                                    fontSize:
                                                        MySizes.fontSizeSm,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailPage(event: event),
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
