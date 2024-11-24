import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';
import 'features/events/controllers/category_controller.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Initialiser les widgets et GetStorage
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Vérifier si c'est la première ouverture
  final storage = GetStorage();
  bool isFirstTime = storage.read('isFirstTime') ?? true;

  runApp(App(isFirstTime: isFirstTime));
}
