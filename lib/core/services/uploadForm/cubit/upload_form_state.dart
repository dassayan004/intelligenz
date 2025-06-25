part of 'upload_form_cubit.dart';

class UploadFormState extends Equatable {
  final List<ImageWithLocation> imagesData;
  final String description;

  const UploadFormState({this.imagesData = const [], this.description = ''});

  UploadFormState copyWith({
    List<ImageWithLocation>? imagesData,
    String? description,
  }) {
    return UploadFormState(
      imagesData: imagesData ?? this.imagesData,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [imagesData, description];
}

class LatLong {
  final double latitude;
  final double longitude;

  const LatLong({required this.latitude, required this.longitude});

  factory LatLong.fromJson(Map<String, dynamic> json) {
    return LatLong(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'latitude': latitude, 'longitude': longitude};
  }
}

class ImageWithLocation {
  final String path;
  final LatLong location;
  final DateTime timestamp;

  ImageWithLocation({
    required this.path,
    required this.location,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now(); // auto-assign if not provided

  factory ImageWithLocation.fromJson(Map<String, dynamic> json) {
    return ImageWithLocation(
      path: json['path'] as String,
      location: LatLong.fromJson(json['location']),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'path': path,
      'location': location.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
