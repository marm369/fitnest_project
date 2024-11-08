import 'package:flutter/material.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class IDVerificationScreen extends StatefulWidget {
  @override
  _IDVerificationScreenState createState() => _IDVerificationScreenState();
}

class _IDVerificationScreenState extends State<IDVerificationScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String frontImagePath =
      'C:\Users\minou\OneDrive\Bureau\frontID.jpg'; // Chemin de l'image de la face avant
  String backImagePath =
      'C:\Users\minou\OneDrive\Bureau\BackID.jpg'; // Chemin de l'image de la face arrière

  Future<void> verifyID() async {
    try {
      String frontText = await FlutterTesseractOcr.extractText(frontImagePath);
      String backText = await FlutterTesseractOcr.extractText(backImagePath);

      if (isMoroccanID(frontText, backText)) {
        final idFirstName = extractFirstName(frontText);
        final idLastName = extractLastName(frontText);

        if (firstNameController.text == idFirstName &&
            lastNameController.text == idLastName) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ID Verified Successfully')));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Name does not match ID')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Not a valid Moroccan ID card')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to verify ID')));
    }
  }

  bool isMoroccanID(String frontText, String backText) {
    // Implémentez la logique pour vérifier les caractéristiques spécifiques de la carte d'identité marocaine
    return frontText.contains('البطاقة الوطنية للتعريف') &&
            frontText.contains('المملكة المغربية') ||
        frontText.contains('CARTE NATIONALE D\'IDENTITE') &&
            frontText.contains('ROYAUME DU MAROC');
  }

  String extractFirstName(String text) {
    // Implémentez la logique pour extraire le prénom du texte
    return 'extractedFirstName';
  }

  String extractLastName(String text) {
    // Implémentez la logique pour extraire le nom de famille du texte
    return 'extractedLastName';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Verification'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            ElevatedButton(
              onPressed: verifyID,
              child: Text('Verify ID'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: IDVerificationScreen()));
