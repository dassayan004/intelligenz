import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';

Future<void> pickImageWithLocation(BuildContext context) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: ImageSource.camera);

  if (!context.mounted) return;

  if (image != null) {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();

      final latLong = LatLong(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!context.mounted) return;

      context.read<UploadFormCubit>().addImageWithLocation(image.path, latLong);
    }
  }
}

String getFileType(String path) {
  final extension = path.split('.').last.toLowerCase();
  return ['mp4', 'mov', 'avi'].contains(extension) ? 'video' : 'image';
}
