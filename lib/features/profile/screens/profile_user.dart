import 'dart:convert';

import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_shapes/curved_edges/groovy_clipper.dart';
import '../../../utils/constants/sizes.dart';
import '../../events/controllers/event_user_controller.dart';
import '../../participation/controllers/participation_controller.dart';
import '../controllers/bio_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';
import 'widgets/event_section.dart';
import 'widgets/interests.dart';
import 'widgets/stat_widget.dart';

class ProfileUser extends StatelessWidget {
  final int participantId;

  // Constructeur pour recevoir participantId
  ProfileUser({required this.participantId});

  final EventUserController eventController = Get.put(EventUserController());
  final ProfileController profileController = Get.put(ProfileController());
  final ParticipationController participationController =
  Get.put(ParticipationController());
  final BioController bioController = Get.put(BioController());
  final TextEditingController bioEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);
    return FutureBuilder<UserModel?>(
        future: profileController.fetchProfileData(
            participantId), // Call fetchProfileData and await the result
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Erreur de récupération du profil.")),
            );
          }

          final UserModel? userProfile =
              snapshot.data; // Retrieve the user profile from the Future result

          if (userProfile == null) {
            return const Scaffold(
              body: Center(child: Text("Échec de la récupération du profil.")),
            );
          }

          // Chargement des événements utilisateur
          final futureEvents = eventController.getEventsByUser(participantId);
          final futureParticipations =
          participationController.getParticipationsByUserId(userProfile.id);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Container(
                    height: 260,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            ClipPath(
                              clipper: GroovyClipper(),
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.27,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: getUserProfileImage(
                                        userProfile.profilePicture),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blue.shade50.withOpacity(0.7),
                                        Colors.blue.shade100.withOpacity(0.7),
                                        Colors.blue.shade200.withOpacity(0.7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // AppBar icons
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: dark ? Colors.black : Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                "${userProfile.firstName} ${userProfile.lastName}",
                                style: TextStyle(
                                  color: dark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MySizes.fontSizeLg,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Profile picture
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.18,
                          left: 16,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 48,
                              backgroundImage: getUserProfileImage(
                                  userProfile.profilePicture),
                            ),
                          ),
                        ),
                        // Bottom profile info
                        Positioned(
                          bottom: 20,
                          left: 120,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: MySizes.standardSpace),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  StatWidget(
                                      label: "Following",
                                      value: "0",
                                      icon: Icons.person_add),
                                  SizedBox(width: MySizes.xs),
                                  StatWidget(
                                      label: "Followers",
                                      value: "0",
                                      icon: Icons.group),
                                  SizedBox(width: MySizes.xs),
                                  StatWidget(
                                      label: "Events",
                                      value: "2",
                                      icon: Icons.event),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Bio section
                      ],
                    ),
                  ),
                  SizedBox(height: MySizes.spaceBtwItems),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: MySizes.md),
                    child: Positioned(
                      top: 400,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: MySizes.standardSpace),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50, // Fond moderne
                          borderRadius:
                          BorderRadius.circular(MySizes.borderRadiusLg),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              blurRadius: MySizes.sm,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Bio",
                                  style: TextStyle(
                                    fontSize: MySizes.fontSizeMd,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ],
                            ),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final bioText = userProfile.description;
                                final showReadMore = bioText.length > 100;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Le texte avec gestion de l'extension ou non
                                    Obx(() => AnimatedContainer(
                                      duration:
                                      const Duration(milliseconds: 200),
                                      child: Text(
                                        bioController.isExpanded.value
                                            ? bioText
                                            : bioText.length > 100
                                            ? '${bioText.substring(0, 100)}...'
                                            : bioText,
                                        style: const TextStyle(
                                          fontSize: MySizes.fontSizeSm - 2,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        maxLines:
                                        bioController.isExpanded.value
                                            ? null
                                            : 3,
                                        // Limite à 3 lignes lorsque non étendu
                                        overflow: bioController
                                            .isExpanded.value
                                            ? TextOverflow.visible
                                            : TextOverflow
                                            .ellipsis, // Gestion du dépassement de texte
                                      ),
                                    )),
                                    SizedBox(height: MySizes.xs),
                                    if (showReadMore)
                                      TextButton(
                                        onPressed: () {
                                          bioController
                                              .toggleExpanded(); // Alterner l'état d'expansion
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Obx(() => Text(
                                          bioController.isExpanded.value
                                              ? "Read Less"
                                              : "Read More",
                                          // Texte du bouton
                                          style: const TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: MySizes.fontSizeXs,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "Your Created Events",
                    style: TextStyle(
                      fontSize: 16.0,
                      // Vous pouvez remplacer MySizes.fontSizeMd par un nombre
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  EventsSectionWidget(
                    futureEvents: futureEvents,
                    altTitle: "You have not organized any events.",
                  ),
                  SizedBox(height: MySizes.spaceBtwSections),
                  Text(
                    "Your Participated Events",
                    style: TextStyle(
                      fontSize: 16.0,
                      // Vous pouvez remplacer MySizes.fontSizeMd par un nombre
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  EventsSectionWidget(
                      futureEvents: futureParticipations,
                      altTitle: "You have not participated any events."),
                  Text(
                    "Interests",
                    style: TextStyle(
                      fontSize: 16.0,
                      // Vous pouvez remplacer MySizes.fontSizeMd par un nombre
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  InterestsWidget(userId: userProfile.id),
                ],
              ),
            ),
          );
        });
  }
}

ImageProvider getUserProfileImage(String? base64Image) {
  if (base64Image != null && base64Image.isNotEmpty) {
    try {
      return MemoryImage(base64Decode(base64Image));
    } catch (e) {
      print("Erreur lors du décodage de l'image : $e");
    }
  }
  return const AssetImage('assets/images/default_user.png');
}