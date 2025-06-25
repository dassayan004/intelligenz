import 'package:hive_flutter/hive_flutter.dart';

part 'upload_model.g.dart';

@HiveType(typeId: 3)
enum UploadStatus {
  @HiveField(0)
  uploading,

  @HiveField(1)
  uploaded,

  @HiveField(2)
  failed,
}

@HiveType(typeId: 4)
class UploadModel extends HiveObject {
  @HiveField(0)
  final String filepath;

  @HiveField(1)
  final int filesize;

  @HiveField(2)
  final String fileType; // 'image' or 'video'

  @HiveField(3)
  final String analyticHashId;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final double latitude;

  @HiveField(6)
  final double longitude;

  @HiveField(7)
  final List<LocationEntry> locations;

  @HiveField(8)
  final int startTimestamp;

  @HiveField(9)
  final int endTimestamp;

  @HiveField(10)
  final int timestamp;

  @HiveField(11)
  final Map<dynamic, dynamic>? apiResponse; // Hive limitation: dynamic key map

  @HiveField(12)
  final UploadStatus status;

  UploadModel({
    required this.filepath,
    required this.filesize,
    required this.fileType,
    required this.analyticHashId,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.locations,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.timestamp,
    this.apiResponse,
    required this.status,
  });
  UploadModel copyWith({
    String? filepath,
    int? filesize,
    String? fileType,
    String? analyticHashId,
    String? description,
    double? latitude,
    double? longitude,
    List<LocationEntry>? locations,
    int? startTimestamp,
    int? endTimestamp,
    int? timestamp,
    Map<dynamic, dynamic>? apiResponse,
    UploadStatus? status,
  }) {
    return UploadModel(
      filepath: filepath ?? this.filepath,
      filesize: filesize ?? this.filesize,
      fileType: fileType ?? this.fileType,
      analyticHashId: analyticHashId ?? this.analyticHashId,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      locations: locations ?? this.locations,
      startTimestamp: startTimestamp ?? this.startTimestamp,
      endTimestamp: endTimestamp ?? this.endTimestamp,
      timestamp: timestamp ?? this.timestamp,
      apiResponse: apiResponse ?? this.apiResponse,
      status: status ?? this.status,
    );
  }
}

@HiveType(typeId: 5)
class LocationEntry extends HiveObject {
  @HiveField(0)
  final int timestamp;

  @HiveField(1)
  final double lat;

  @HiveField(2)
  final double long;

  LocationEntry({
    required this.timestamp,
    required this.lat,
    required this.long,
  });
}
