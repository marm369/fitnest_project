import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../common/widgets/drop_down/category_event_drop_down.dart';
import '../maps/screens/city_search_screen.dart';

class EventForm extends StatefulWidget {
  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  File? _eventImage;
  int _participantCount = 1;
  String? selectedCategory;

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _eventImage = File(pickedImage.path);
      });
    }
  }

  void incrementParticipantCount() {
    setState(() {
      _participantCount++;
    });
  }

  void decrementParticipantCount() {
    setState(() {
      if (_participantCount > 1) _participantCount--;
    });
  }

  Future<void> _submitForm() async {
    print("Nom : ${_nameController.text}");
    print("Description : ${_descriptionController.text}");
    print("Lieu : Casablanca");
    print("Date de début : $_startDate");
    print("Date de fin : $_endDate");
    print("Heure de départ : ${_startTime!.format(context)}");
    print("Nombre de participants : $_participantCount");
    print("Catégorie sélectionnée : $selectedCategory");
    print("Image sélectionnée : ${_eventImage != null}");

    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationNameController.text.isEmpty ||
        _startDate == null ||
        _endDate == null ||
        _startTime == null ||
        _eventImage == null ||
        selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Veuillez remplir tous les champs, ajouter une image et choisir une catégorie")),
      );
      return;
    }
    String base64Image = base64Encode(await _eventImage!.readAsBytes());
    // Créer le corps de la requête
    Map<String, dynamic> requestBody = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "location": {
        "latitude": 33.576, // Remplacez par des valeurs dynamiques si besoin
        "longitude": -7.6351,
      },
      "locationName": _locationNameController.text,
      "startDate": _startDate?.toIso8601String().split('T')[0],
      "endDate": _endDate?.toIso8601String().split('T')[0],
      "sportCategory": selectedCategory,
      "numberOfParticipants": _participantCount,
      "currentNumberOfParticipants": 0,
      "imagePath": base64Image,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.0.121:8080/api/events/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Événement créé avec succès!")),
        );
      } else {
        print(
            "Erreur lors de la création de l'événement : ${response.statusCode}");
        print("Corps de la réponse : ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Erreur lors de la création de l'événement : ${response.body}")),
        );
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur de connexion au serveur")),
      );
    }
  }

  void _viewMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CitySearchMapScreen(placeName: _locationNameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Créer un Événement")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nom de l'événement"),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: "Description"),
            ),
            SizedBox(height: 16.0),
            CategoryDropdown(
              onCategorySelected: (category) {
                setState(() {
                  selectedCategory = category;
                });
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, true),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _startDate == null
                            ? "Choisir la date de début"
                            : "Début: ${DateFormat('dd/MM/yyyy').format(_startDate!)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selectDate(context, false),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        _endDate == null
                            ? "Choisir la date de fin"
                            : "Fin: ${DateFormat('dd/MM/yyyy').format(_endDate!)}",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: () => _selectStartTime(context),
              child: Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  _startTime == null
                      ? "Choisir l'heure de départ"
                      : "Heure de départ: ${_startTime?.format(context)}",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _locationNameController,
                    decoration: InputDecoration(labelText: "Emplacement"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.map),
                  onPressed: _viewMap,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  onPressed: decrementParticipantCount,
                ),
                Text(
                  '$_participantCount',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  icon: Icon(Icons.add_circle_outline),
                  onPressed: incrementParticipantCount,
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Choisir une image"),
            ),
            if (_eventImage != null) ...[
              SizedBox(height: 16.0),
              Image.file(
                _eventImage!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ],
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text("Soumettre"),
            ),
          ],
        ),
      ),
    );
  }
}
