import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/core/services/upload/upload_repository.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/core/utils/build_upload_model.dart';
import 'package:intelligenz/db/upload/upload_model.dart';

import 'upload_state.dart';

class UploadCubit extends Cubit<UploadState> {
  final UploadRepository _repository;

  UploadCubit(this._repository) : super(UploadInitial());
  final Box<UploadModel> _uploadBox = Hive.box<UploadModel>(uploadBox);

  Future<void> fetchAllUploads() async {
    final uploads = _uploadBox.values.toList();
    emit(UploadListLoaded(uploads));
  }

  UploadModel? findUploadById(int key) {
    return _uploadBox.get(key);
  }

  Future<void> submitUpload(
    UploadFormState formState,
    String analyticHashId,
  ) async {
    if (formState.imagesData.isEmpty) {
      emit(UploadFailure("Please select at least one file."));
      return;
    }

    emit(UploadInProgress());

    try {
      for (final image in formState.imagesData) {
        final file = File(image.path);
        final model = await buildUploadModel(
          file: file,
          filePath: image.path,
          analyticHashId: analyticHashId,
          description: formState.description,
          image: image,
          locations: [], // Add video locations if available
        );

        // Save initial model to Hive with `uploading` status
        final key = await _uploadBox.add(model);
        print("key: ${key.toString()}");
        // try {
        //   // Upload to API
        //   final response = await _repository.uploadPhoto(
        //     file: file,
        //     analyticHashId: analyticHashId,
        //     description: formState.description,
        //     location: image.location,
        //   );

        //   // Update Hive entry on success
        //   final updated = UploadModel(
        //     filepath: model.filepath,
        //     filesize: model.filesize,
        //     fileType: model.fileType,
        //     analyticHashId: model.analyticHashId,
        //     description: model.description,
        //     latitude: model.latitude,
        //     longitude: model.longitude,
        //     locations: model.locations,
        //     startTimestamp: model.startTimestamp,
        //     endTimestamp: model.endTimestamp,
        //     timestamp: model.timestamp,
        //     apiResponse: Map<String, dynamic>.from(response),
        //     status: UploadStatus.uploaded,
        //   );

        //   await _uploadBox.put(key, updated);
        // } catch (e) {
        //   // Update Hive entry on failure
        //   final failed = model.copyWith(
        //     status: UploadStatus.failed,
        //     apiResponse: {"error": e.toString()},
        //   );
        //   await _uploadBox.put(key, failed);
        // }
      }

      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure(e.toString()));
    }
  }
}
