import 'dart:convert';
import 'package:fitnest/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../models/post_model.dart';

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
  bool isLiked = false; // État pour savoir si le heart est activé
  int likeCount = 100; // Nombre initial de likes

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
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
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: widget.post.organizerImage != null &&
                          widget.post.organizerImage!.isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage(widget.post.organizerImage!),
                        fit: BoxFit.cover,
                      )
                          : null,
                      color: Colors.grey.shade300,
                    ),
                    child: widget.post.organizerImage == null ||
                        widget.post.organizerImage!.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
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
                    child: Icon(iconMapping[widget.post.sportCategoryIcon],color: Colors.grey,),

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
