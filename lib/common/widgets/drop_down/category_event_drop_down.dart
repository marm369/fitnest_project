import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoryDropdown extends StatefulWidget {
  final Function(String)
      onCategorySelected; // Ajout du callback pour la catégorie sélectionnée

  CategoryDropdown(
      {required this.onCategorySelected}); // Modifiez le constructeur pour accepter le callback

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  String? selectedCategory;
  List<dynamic> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Fetch categories when the widget initializes
  }

  // Fetch categories from your API
  Future<void> fetchCategories() async {
    final response = await http.get(
        Uri.parse('http://192.168.0.121:8080/api/categories/getCategories'));

    if (response.statusCode == 200) {
      setState(() {
        categories = json.decode(response.body); // Parse the JSON response
        isLoading = false; // Set loading to false after fetching data
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: 7.0), // Adjust padding for compactness
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400, width: 1), // Add border
      ),
      child: SizedBox(
        width: 200, // Set the width of the dropdown
        child: DropdownButtonHideUnderline(
          // Remove default underline
          child: DropdownButton<String>(
            value: selectedCategory,
            hint: Text(
              'Select a category',
              style: TextStyle(
                  fontSize: 14), // Adjust font size for compact appearance
            ),
            icon: Icon(Icons.arrow_drop_down, size: 24), // Adjust the icon size
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue;
                widget.onCategorySelected(
                    newValue!); // Appel du callback avec la catégorie sélectionnée
                // Affiche la catégorie sélectionnée dans la console
                print('Selected category: $selectedCategory');
              });
            },
            items: categories.map<DropdownMenuItem<String>>((dynamic category) {
              return DropdownMenuItem<String>(
                value: category['name'],
                child: Row(
                  children: [
                    if (category['iconPath'] != null)
                      Image.asset(
                        category[
                            'iconPath'], // Load icon from asset path if available
                        width: 20, // Adjust icon size
                        height: 20,
                      ),
                    SizedBox(width: 8), // Reduce space between icon and text
                    Text(
                      category['name'],
                      style: TextStyle(fontSize: 14), // Smaller text size
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
