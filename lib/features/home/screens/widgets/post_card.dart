import 'dart:convert';

import 'package:fitnest/utils/constants/icons.dart';
import 'package:fitnest/utils/constants/sizes.dart';
import 'package:fitnest/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../events/models/event.dart';
import '../../../events/screens/detail_event.dart';
import '../../../participation/controllers/participation_controller.dart';
import '../../../profile/screens/profile_user.dart';
import '../../controllers/home_controller.dart';
import '../../models/post_model.dart';

class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onTap;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likeCount = 100;

  final ParticipationController participationController =
      Get.put(ParticipationController());

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final dark = HelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () async {
        Event event = await homeController.getEventById(widget.post.id);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailPage(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: dark ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.white, // Couleur de la bordure
            width: 1, // Largeur de la bordure
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  // Organizer's Image
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileUser(
                            participantId: widget.post.organizerId,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: widget.post.organizerImage != null &&
                                widget.post.organizerImage!.isNotEmpty
                            ? DecorationImage(
                                image: MemoryImage(
                                  base64Decode(widget
                                      .post.organizerImage), // Décodage Base64
                                ),
                                fit: BoxFit
                                    .cover, // Maintient le ratio de l'image
                              )
                            : null,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.post.organizerFirstName} ${widget.post.organizerLastName}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${widget.post.cityName ?? "Lieu non spécifié"} • ${widget.post.startTime}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Icon(
                      iconMapping[widget.post.sportCategoryIcon],
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.post.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ),

            // Image
            Padding(
              padding: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildPostImage(widget.post.imagePath),
              ),
            ),

            // Interaction Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                            likeCount += isLiked ? 1 : -1;
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '$likeCount',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 15),
                      SvgPicture.asset(MyImages.kChat, color: Colors.grey),
                      const SizedBox(width: 5),
                      Text(
                        '30',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  SizedBox(width: MySizes.spaceBtwSections * 4),
                  if (participationController.userId != widget.post.organizerId)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      dark ? Colors.black : Colors.white,
                                  contentPadding: EdgeInsets.all(20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Bordure arrondie
                                  ),
                                  title: Center(
                                    child: Text(
                                      'Invitation Sent',
                                      style: TextStyle(
                                        fontSize: 18, // Taille du titre
                                        fontWeight: FontWeight.bold,
                                        color:
                                            dark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                  content: Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Your invitation request is sent to the organizer.',
                                      style: TextStyle(
                                        fontSize: 14, // Taille du texte
                                        color: dark
                                            ? Colors.white.withOpacity(0.7)
                                            : Colors.black.withOpacity(
                                                0.7), // Texte légèrement gris
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              },
                            );
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context)
                                  .pop(); // Ferme le pop-up après 2 secondes
                            });

                            // Créer la participation
                            participationController.createParticipation(
                              eventId: widget.post.id,
                              organizerId: widget.post.organizerId,
                            );
                          },
                          child: Container(
                            width: 80, // Largeur du bouton ajustée
                            height: 35, // Hauteur du bouton ajustée
                            decoration: BoxDecoration(
                              color: Colors.white, // Fond blanc
                              borderRadius:
                                  BorderRadius.circular(20), // Bordure arrondie
                              border: Border.all(
                                color: Colors.grey.shade300, // Bordure grise
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Join', // Texte du bouton
                                style: TextStyle(
                                  fontSize: 14, // Taille du texte ajustée
                                  fontWeight: FontWeight.bold, // Style du texte
                                  color:
                                      Colors.grey.shade600, // Texte gris clair
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(),
                  Row(
                    children: [
                      SvgPicture.asset(MyImages.kShare, color: Colors.grey),
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

  Widget _buildPostImage(String imagePath) {
    try {
      final isBase64Image = imagePath.isNotEmpty &&
          RegExp(r'^[A-Za-z0-9+/=]+\s*$').hasMatch(imagePath);

      if (isBase64Image) {
        final imageBytes = base64Decode(imagePath);
        return Image.memory(
          imageBytes,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          imagePath,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            width: double.infinity,
            height: 200,
            color: Colors.grey.shade200,
            child: const Center(
              child: Text(
                'Image indisponible',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      return Container(
        width: double.infinity,
        height: 200,
        color: Colors.grey.shade200,
        child: const Center(
          child: Text(
            'Image indisponible',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
  }
}
