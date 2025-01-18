import 'package:permission_handler/permission_handler.dart';
class PermissionLocation{
  Future<void> _requestPermission() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      // La permission a été accordée, vous pouvez continuer à récupérer la localisation
    } else {
      // La permission a été refusée
      print("Location permission denied");
    }
  }
}

