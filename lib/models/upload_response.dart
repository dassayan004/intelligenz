import 'package:intelligenz/db/upload/upload_model.dart';

extension UploadModelExtension on UploadModel {
  Map<String, dynamic> toJson() => {
    'filepath': filepath,
    'filesize': filesize,
    'fileType': fileType,
    'analyticHashId': analyticHashId,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'locations': locations.map((e) => e.toJson()).toList(),
    'startTimestamp': startTimestamp,
    'endTimestamp': endTimestamp,
    'timestamp': timestamp,
    'apiResponse': apiResponse,
    'status': status.name,
  };
}

extension LocationEntryExtension on LocationEntry {
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp,
    'lat': lat,
    'long': long,
  };
}
