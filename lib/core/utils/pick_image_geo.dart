import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligenz/core/services/permission_service.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';

Future<void> pickImageWithLocation(BuildContext context) async {
  final picker = ImagePicker();
  final pickedImage = await picker.pickImage(source: ImageSource.camera);

  if (!context.mounted || pickedImage == null) return;
  final hasPermission = await ensureLocationPermission();
  if (!hasPermission) {
    // Optionally show a dialog or toast here
    return;
  }
  try {
    final position = await Geolocator.getCurrentPosition();
    final latLong = LatLong(
      latitude: position.latitude,
      longitude: position.longitude,
    );

    if (context.mounted) {
      context.read<UploadFormCubit>().addImageWithLocation(
        pickedImage.path,
        latLong,
      );
    }
  } catch (e) {
    debugPrint("📍 Error fetching location: $e");
  }
}

String getFileType(String path) {
  final extension = path.split('.').last.toLowerCase();
  return ['mp4', 'mov', 'avi'].contains(extension) ? 'video' : 'image';
}
