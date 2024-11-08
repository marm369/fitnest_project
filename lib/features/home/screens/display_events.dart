import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EventCardScreen extends StatefulWidget {
  @override
  _EventCardScreenState createState() => _EventCardScreenState();
}

class _EventCardScreenState extends State<EventCardScreen> {
  Future<List<dynamic>> fetchEvents() async {
    final response = await http
        .get(Uri.parse('http://192.168.0.121:8080/api/events/getAllEvents'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Pas besoin de mapper vers une classe
    } else {
      throw Exception('Échec du chargement des événements');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des événements"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Échec du chargement des événements"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucun événement disponible"));
          }

          final events = snapshot.data!;
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    event['imagePath'] != null
                        ? Image.memory(base64Decode(event['imagePath']))
                        : SizedBox(
                            height: 150,
                            child: Icon(Icons.image, size: 50),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['name'] ?? '',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(event['description'] ?? ''),
                          SizedBox(height: 8),
                          Text("Lieu : ${event['locationName'] ?? ''}"),
                          Text("Sport : ${event['sportCategory'] ?? ''}"),
                          Text(
                              "Date : ${event['startDate']} - ${event['endDate']}"),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
