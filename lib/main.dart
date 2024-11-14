import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_storage/get_storage.dart';
import 'app.dart';

Future<void> main() async {
  // Initialiser les widgets et GetStorage
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Vérifier si c'est la première ouverture
  final storage = GetStorage();
  bool isFirstTime = storage.read('isFirstTime') ?? true;

  runApp(App(isFirstTime: isFirstTime));
}


/*
*
git stash          # Saves your changes in a stash and clears your working directory
git pull           # Pulls the latest changes from the remote
git stash pop      # Applies the stashed changes back and removes them from the stash list
*/
