import 'dart:io';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/core/utils/pick_image_geo.dart';
import 'package:intelligenz/db/upload/upload_model.dart';

Future<UploadModel> buildUploadModel({
  required File file,
  required String filePath,
  required String analyticHashId,
  required String description,
  required ImageWithLocation image,
  List<LocationEntry> locations = const [],
}) async {
  final fileType = getFileType(filePath);
  final fileSize = await file.length();

  if (fileType == 'image') {
    return UploadModel(
      filepath: filePath,
      filesize: fileSize,
      fileType: 'image',
      analyticHashId: analyticHashId,
      description: description,
      latitude: image.location.latitude,
      longitude: image.location.longitude,
      timestamp: image.timestamp.millisecondsSinceEpoch ~/ 1000,
      locations: [],
      startTimestamp: 0,
      endTimestamp: 0,
      apiResponse: null,
      status: UploadStatus.uploading,
    );
  } else {
    return UploadModel(
      filepath: filePath,
      filesize: fileSize,
      fileType: 'video',
      analyticHashId: analyticHashId,
      description: description,
      latitude: 0,
      longitude: 0,
      timestamp: 0,
      locations: locations,
      startTimestamp: locations.isNotEmpty ? locations.first.timestamp : 0,
      endTimestamp: locations.isNotEmpty ? locations.last.timestamp : 0,
      apiResponse: null,
      status: UploadStatus.uploading,
    );
  }
}
