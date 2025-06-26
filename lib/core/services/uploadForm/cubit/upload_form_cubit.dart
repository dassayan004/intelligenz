import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intelligenz/core/services/permission_service.dart';

part 'upload_form_state.dart';

class UploadFormCubit extends Cubit<UploadFormState> {
  UploadFormCubit() : super(const UploadFormState());

  void addImageWithLocation(String path, LatLong location) {
    final updated = List<ImageWithLocation>.from(state.imagesData)
      ..add(ImageWithLocation(path: path, location: location));
    emit(state.copyWith(imagesData: updated));
  }

  void removeImageAt(int index) {
    final updated = List<ImageWithLocation>.from(state.imagesData)
      ..removeAt(index);
    emit(state.copyWith(imagesData: updated));
  }

  void updateDescription(String desc) {
    emit(state.copyWith(description: desc));
  }

  Future<bool> addImageAndFetchLocation(String path) async {
    final hasPermission = await ensureLocationPermission();

    if (!hasPermission) return false;
    try {
      final position = await Geolocator.getCurrentPosition();
      final latLong = LatLong(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      addImageWithLocation(path, latLong);
      return true;
    } catch (e) {
      return false;
    }
  }
}
