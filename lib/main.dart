import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Vérifier si c'est la première ouverture
  final storage = GetStorage();
  bool isFirstTime = storage.read('isFirstTime') ?? true;

  runApp(App(isFirstTime: isFirstTime));
}
