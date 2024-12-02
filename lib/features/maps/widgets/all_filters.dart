import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String? _selectedDate = 'Today';
  String? _selectedTime = 'Any Time';
  String? _selectedDistance = 'Any Distance';
  String? _selectedCategory = 'Sport';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtres'),
      ),
      body: Center(
        child: Text(
            'Contenu de l\'application'), // Remplacez par le contenu de votre application
      ),
    );
  }

  // Affiche la feuille modale avec les options de filtre
  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: ListView(
                controller: scrollController,
                children: [
                  _buildHeader(context),
                  _buildDateSection(),
                  _buildTimeSection(),
                  _buildDistanceSection(),
                  _buildCategorySection(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour appliquer les filtres
                      Navigator.pop(context);
                    },
                    child: Text('Appliquer'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Fonction d’entête avec bouton de réinitialisation
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Annuler'),
        ),
        Text('Filtres',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: () {
            setState(() {
              _selectedDate = 'Today';
              _selectedTime = 'Any Time';
              _selectedDistance = 'Any Distance';
              _selectedCategory = 'Sport';
            });
          },
          child: Text('Réinitialiser'),
        ),
      ],
    );
  }

  // Génération d’une section de boutons radio
  Widget _buildRadioSection({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...options.map((option) {
          return ListTile(
            title: Text(option),
            leading: Radio<String>(
              value: option,
              groupValue: selectedValue,
              onChanged: onChanged,
            ),
          );
        }).toList(),
        SizedBox(height: 20),
      ],
    );
  }

  // Sections individuelles pour les options de filtre
  Widget _buildDateSection() {
    return _buildRadioSection(
      title: 'By Date',
      options: ['Today', 'Tomorrow', 'This Week', 'Next Week'],
      selectedValue: _selectedDate,
      onChanged: (value) {
        setState(() {
          _selectedDate = value;
        });
      },
    );
  }

  Widget _buildTimeSection() {
    return _buildRadioSection(
      title: 'Time of Day',
      options: ['Any Time', 'Morning', 'Afternoon', 'Evening', 'Night'],
      selectedValue: _selectedTime,
      onChanged: (value) {
        setState(() {
          _selectedTime = value;
        });
      },
    );
  }

  Widget _buildDistanceSection() {
    return _buildRadioSection(
      title: 'Distance',
      options: ['Any Distance', '1km', '2km', '5km', '10km', '20km'],
      selectedValue: _selectedDistance,
      onChanged: (value) {
        setState(() {
          _selectedDistance = value;
        });
      },
    );
  }

  Widget _buildCategorySection() {
    return _buildRadioSection(
      title: 'Category',
      options: ['Run', 'Cyclist', 'Hike', 'VolleyBall'],
      selectedValue: _selectedCategory,
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }
}
