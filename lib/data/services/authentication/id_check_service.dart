import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import '../../../configuration/config.dart';

class IdCheckService {
  Future<String?> extractTextFromImage(File imageFile) async {
    // API endpoint
    final url = Uri.parse('https://api.ocr.space/parse/image');

    // Define headers and parameters
    final headers = {
      'apikey': '$OCRAPIkey',
    };

    final request = http.MultipartRequest('POST', url)
      ..headers.addAll(headers)
      ..fields['language'] = 'fre' // Langue française
      ..fields['OCREngine'] = '2' // Spécifier Engine 2
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    try {
      // Send the request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Process the response
      if (response.statusCode == 200) {
        final data = json.decode(responseBody);

        if (data['IsErroredOnProcessing'] == true) {
          print("Error: ${data['ErrorMessage'][0]}");
          return null;
        } else {
          final extractedText = data['ParsedResults'][0]['ParsedText'];
          return extractedText;
        }
      } else {
        print(
            "Error: Failed to reach OCR.space API. Status code: ${response.statusCode}");
        return null; // Return null if the API request failed
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null; // Return null if an exception occurs during the request
    }
  }
}
