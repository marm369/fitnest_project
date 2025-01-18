import 'dart:convert';

import 'package:fitnest/data/services/event/event_service.dart';
import 'package:http/http.dart' as http;

import '../../../configuration/config.dart';
import '../../../features/events/models/event.dart';
import '../../../features/home/models/post_model.dart';

class PostService {
  final String baseUrl = '$GatewayUrl/event-service/api/events'; // URL des événements

  // Méthode pour récupérer tous les posts
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/all-details'));

      if (response.statusCode == 200) {
        final body = json.decode(utf8.decode(response.bodyBytes));
        List<Event> events =
        (body as List).map((dynamic item) => Event.fromJson(item)).toList();
        // Convertir les événements en PostModel avec récupération des données utilisateur
        List<PostModel> posts = [];
        for (var event in events) {
          print("-------------loc infos --------------------");
          print(event.location);
          final user =
          await _fetchUserById(event.organizerId);

          final post = PostModel.fromEvent(event,
              user: user); // Pass user data to PostModel
          posts.add(post);
        }

        return posts;
      } else {
        throw Exception('Impossible de charger les événements');
      }
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  // Méthode pour récupérer les détails de l'utilisateur à partir de son ID
  Future<Map<String, dynamic>> _fetchUserById(int organizerId) async {
    try {
      final userResponse = await http.get(
        Uri.parse('$GatewayUrl/auth-service/user/getUserById/$organizerId'),
      );

      if (userResponse.statusCode == 200) {
        return json.decode(utf8.decode(userResponse.bodyBytes));
      } else {
        throw Exception('Impossible de charger l\'utilisateur');
      }
    } catch (e) {
      throw Exception('Erreur de récupération de l\'utilisateur : $e');
    }
  }
}
