import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<void> requestNecessaryPermissions() async {
    // Location permission
    await Permission.location.request();

    // Camera permission
    await Permission.camera.request();

    // Storage (Android only)
    await Permission.photos.request(); // or Permission.storage

    // You can also check statuses:
    if (await Permission.location.isPermanentlyDenied) {
      // Guide the user to settings
      openAppSettings();
    }
  }

  Future<bool> hasAllPermissions() async {
    final locationGranted = await Permission.location.isGranted;
    final cameraGranted = await Permission.camera.isGranted;
    final storageGranted = await Permission.photos.isGranted;

    return locationGranted && cameraGranted && storageGranted;
  }
}

Future<bool> ensureLocationPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    // Optionally guide user to settings
    return false;
  }

  return permission == LocationPermission.always ||
      permission == LocationPermission.whileInUse;
}
