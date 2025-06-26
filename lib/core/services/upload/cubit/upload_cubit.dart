import 'dart:io';

import 'package:dio/dio.dart';
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
    String analyticName,
  ) async {
    if (formState.imagesData.isEmpty) {
      emit(UploadFailure("Please select at least one file."));
      return;
    }

    // 1. Save all uploads to Hive with `uploading` status
    for (final image in formState.imagesData) {
      final file = File(image.path);
      final model = await buildUploadModel(
        file: file,
        filePath: image.path,
        analyticHashId: analyticHashId,
        analyticName: analyticName,
        description: formState.description,
        image: image,
        locations: [],
      );

      final key = await _uploadBox.add(model);

      // 2. Emit updated list (optional if you're already showing latest)
      emit(UploadListLoaded(_uploadBox.values.toList()));

      // 3. Start background upload
      _uploadFileInBackground(
        key,
        model,
        file,
        analyticHashId,
        image.location,
        formState.description,
      );
    }

    // 4. Let user go immediately (no await!)
    emit(UploadSuccess());
  }

  void _uploadFileInBackground(
    int key,
    UploadModel model,
    File file,
    String analyticHashId,
    LatLong location,
    String description,
  ) async {
    try {
      final response = await _repository.uploadPhoto(
        file: file,
        analyticHashId: analyticHashId,
        description: description,
        location: location,
        timestamp: model.timestamp,
      );

      final updated = model.copyWith(
        status: UploadStatus.uploaded,
        apiResponse: Map<String, dynamic>.from(response),
      );

      await _uploadBox.put(key, updated);
    } on DioException catch (e) {
      final failed = model.copyWith(
        status: UploadStatus.failed,
        apiResponse: Map<String, dynamic>.from(e.response?.data ?? {}),
      );
      await _uploadBox.put(key, failed);
    }

    // Optional: re-emit to refresh UI
    emit(UploadListLoaded(_uploadBox.values.toList()));
  }

  Future<void> retryUpload(int key) async {
    final model = _uploadBox.get(key);

    if (model == null || model.status != UploadStatus.failed) return;

    final file = File(model.filepath);
    final location = LatLong(
      latitude: model.latitude,
      longitude: model.longitude,
    );

    // Update status to uploading
    final uploading = model.copyWith(status: UploadStatus.uploading);
    await _uploadBox.put(key, uploading);
    emit(UploadListLoaded(_uploadBox.values.toList()));
    _uploadFileInBackground(
      key,
      model,
      file,
      model.analyticHashId,
      location,
      model.description,
    );
  }
}
