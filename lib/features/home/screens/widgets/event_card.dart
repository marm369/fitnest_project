import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../events/models/event.dart';
import '../../../events/screens/detail_event.dart';
import '../../../profile/screens/profile_user.dart';
import '../../controllers/home_controller.dart';

class EventCard extends StatelessWidget {
  final int id;
  final String title;
  final String eventImage;
  final DateTime date;
  final String profileImage;
  final String organizer;
  final int organizerId;

  const EventCard({
    Key? key,
    required this.id,
    required this.title,
    required this.eventImage,
    required this.date,
    required this.profileImage,
    required this.organizer,
    required this.organizerId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    return GestureDetector(
      onTap: () async {
        Event event = await homeController.getEventById(id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(MySizes.sm),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(MySizes.sm)),
              child: Builder(
                builder: (context) {
                  try {
                    // Vérifier si l'image est encodée en base64
                    final isBase64Image = eventImage.isNotEmpty &&
                        RegExp(r'^[A-Za-z0-9+/=]+\s*$').hasMatch(eventImage);

                    if (isBase64Image) {
                      // Décoder l'image base64
                      final imageBytes = base64Decode(eventImage);

                      return Image.memory(
                        imageBytes,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover, // Maintient le ratio de l'image
                      );
                    } else {
                      // Si l'image n'est pas en base64, utiliser une URL réseau
                      return Image.network(
                        eventImage,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover, // Maintient le ratio de l'image
                      );
                    }
                  } catch (e) {
                    // En cas d'erreur, retourner un conteneur vide ou un widget alternatif
                    return SizedBox(
                      height: 80,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Image indisponible',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: MySizes.fontSizeMd,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    overflow: TextOverflow.ellipsis, // handles overflow text
                  ),
                  SizedBox(height: MySizes.xs / 2),
                  Text(
                    DateFormat('dd-MM-yyyy').format(date),
                    style: TextStyle(
                      fontSize: MySizes.fontSizeXs,
                      color: Colors.grey[600],
                    ),
                  ),
                  Divider(color: Colors.grey),
                  Row(
                    children: [
                      // Affichage de l'image dans un CircleAvatar avec gestion des erreurs
                      Builder(
                        builder: (context) {
                          try {
                            // Décoder l'image base64
                            final imageBytes = base64Decode(profileImage);
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileUser(
                                      participantId: organizerId,
                                    ),
                                  ),
                                );
                              },
                              child: CircleAvatar(
                                radius:
                                    MySizes.md, // Ajustez la taille du cercle
                                backgroundImage: MemoryImage(
                                    imageBytes), // Afficher l'image à partir de la mémoire
                              ),
                            );
                          } catch (e) {
                            // En cas d'erreur, retourner un CircleAvatar vide
                            return CircleAvatar(
                              radius: MySizes.md,
                            );
                          }
                        },
                      ),
                      SizedBox(width: MySizes.sm),
                      // Espacement entre l'image et le texte
                      Expanded(
                        child: Text(
                          organizer,
                          style: TextStyle(
                            fontSize: MySizes.fontSizeSm,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Gère le débordement du texte
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.map,
                          color: Colors.redAccent,
                          size: MySizes.iconMd,
                        ),
                        onPressed: () {
                          // Action pour l'icône de carte
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Open Map for $title')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
