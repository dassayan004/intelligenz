import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelligenz/core/services/upload/upload_repository.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';

import 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  final UploadRepository repository;

  UploadCubit({required this.repository}) : super(UploadInitial());
  Future<void> submitUpload(
    UploadFormState formState,
    String analyticHashId,
  ) async {
    if (formState.imagesData.isEmpty) {
      emit(UploadFailure("Please select at least one image."));
      return;
    }

    emit(UploadInProgress());

    try {
      final imageWithLocation = formState.imagesData.first;

      final file = File(imageWithLocation.path);
      final location = imageWithLocation.location;
      await repository.uploadPhoto(
        file: file,
        analyticHashId: analyticHashId,
        description: formState.description,
        location: location,
      );
      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }
}
