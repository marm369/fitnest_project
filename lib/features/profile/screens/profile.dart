import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'settings.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.arrow_back),
          title: Text("maryem minouari"),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                // Navigation vers la page des paramètres
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(MySizes.spaceBtwItems),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/images/user2.jpg'), // Remplace par l'URL de ton image
                  ),
                  SizedBox(height: MySizes.standardSpace),
                  Text(
                    "minou",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MySizes.fontSizeLg),
                  ),
                  SizedBox(height: MySizes.standardSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStat("Following", "0"),
                      _buildStat("Followers", "0"),
                      _buildStat("Events", "2"),
                    ],
                  ),
                  SizedBox(height: MySizes.standardSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          minimumSize: Size(120, 30),
                        ),
                        child: Text("Follow"),
                      ),
                      SizedBox(width: MySizes.spaceBtwItems),
                      OutlinedButton(
                        onPressed: () {},
                        child: Icon(Icons.email),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Tabs

            // Tab content
            Expanded(
              child: TabBarView(
                children: [
                  _buildImageGrid(),
                ],
              ),
            ),
          ],
        ),
        // Bottom Navigation Bar
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 2, // Nombre d'images
      itemBuilder: (context, index) {
        return Container(
          color: Colors.grey[300],
          child: Image.asset('assets/images/post${index + 1}.jpeg',
              fit: BoxFit.cover),
        );
      },
    );
  }
}
