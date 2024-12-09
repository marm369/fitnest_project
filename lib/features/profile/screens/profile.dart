import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/custom_shapes/curved_edges/groovy_clipper.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../events/controllers/event_user_controller.dart';
import '../../events/models/event.dart';
import '../../events/screens/detail_event.dart';
import '../controllers/bio_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_model.dart';
import 'settings.dart';
import 'widgets/stat_widget.dart';

class ProfileScreen extends StatelessWidget {
  final EventUserController eventController = Get.put(EventUserController());
  final ProfileController profileController = Get.put(ProfileController());
  final BioController bioController = Get.put(BioController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (profileController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Gestion des erreurs ou données manquantes
      final userProfile = profileController.userProfile.value;
      if (userProfile == null) {
        return const Scaffold(
          body: Center(child: Text("Échec de la récupération du profil.")),
        );
      }

      // Chargement des événements utilisateur
      final futureEvents = eventController.getEventsByUser(userProfile.id);

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
                            height: MediaQuery.of(context).size.height * 0.27,
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
                                    Colors.blue.shade200.withOpacity(0.7),
                                    Colors.blue.shade400.withOpacity(0.7),
                                    Colors.blue.shade600.withOpacity(0.9),
                                    Colors.blue.shade800.withOpacity(0.9),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          Text(
                            "${userProfile.firstName} ${userProfile.lastName}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MySizes.fontSizeLg,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              );
                            },
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
                          backgroundImage:
                              getUserProfileImage(userProfile.profilePicture),
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
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blueAccent,
                                size: MySizes.iconSm,
                              ),
                              onPressed: () {
                                // Action pour modifier le bio
                                //_editBio(context, userProfile.description ?? "");
                              },
                            ),
                          ],
                        ),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final bioText =
                                "Ajoutez votre biographie ici. Ceci est un texte de test long pour vérifier la fonctionnalité 'Read More'. Nous allons ajouter suffisamment de texte ici pour tester comment le bouton 'Read More' fonctionne. La bio s'affichera partiellement au début, et l'utilisateur pourra cliquer sur 'Read More' pour voir le texte complet. Ce texte est volontairement long pour s'assurer que tout fonctionne correctement.";
                            final showReadMore =
                                bioText.length > 100; // Limite dynamique
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
                                        maxLines: bioController.isExpanded.value
                                            ? null
                                            : 3, // Limite à 3 lignes lorsque non étendu
                                        overflow: bioController.isExpanded.value
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
                                              : "Read More", // Texte du bouton
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
              _buildEventsSection(futureEvents, context),
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

Widget _buildEventsSection(
    Future<List<Event>> futureEvents, BuildContext context) {
  return Flexible(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Text(
            "Events organized by me",
            style: TextStyle(
              fontSize: MySizes.fontSizeMd,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
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
