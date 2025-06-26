// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UploadModelAdapter extends TypeAdapter<UploadModel> {
  @override
  final int typeId = 4;

  @override
  UploadModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UploadModel(
      filepath: fields[0] as String,
      filesize: fields[1] as int,
      fileType: fields[2] as String,
      analyticHashId: fields[3] as String,
      analyticName: fields[4] as String,
      description: fields[5] as String,
      latitude: fields[6] as double,
      longitude: fields[7] as double,
      locations: (fields[8] as List).cast<LocationEntry>(),
      startTimestamp: fields[9] as int,
      endTimestamp: fields[10] as int,
      timestamp: fields[11] as int,
      apiResponse: (fields[12] as Map?)?.cast<dynamic, dynamic>(),
      status: fields[13] as UploadStatus,
    );
  }

  @override
  void write(BinaryWriter writer, UploadModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.filepath)
      ..writeByte(1)
      ..write(obj.filesize)
      ..writeByte(2)
      ..write(obj.fileType)
      ..writeByte(3)
      ..write(obj.analyticHashId)
      ..writeByte(4)
      ..write(obj.analyticName)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.latitude)
      ..writeByte(7)
      ..write(obj.longitude)
      ..writeByte(8)
      ..write(obj.locations)
      ..writeByte(9)
      ..write(obj.startTimestamp)
      ..writeByte(10)
      ..write(obj.endTimestamp)
      ..writeByte(11)
      ..write(obj.timestamp)
      ..writeByte(12)
      ..write(obj.apiResponse)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LocationEntryAdapter extends TypeAdapter<LocationEntry> {
  @override
  final int typeId = 5;

  @override
  LocationEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationEntry(
      timestamp: fields[0] as int,
      lat: fields[1] as double,
      long: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, LocationEntry obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.lat)
      ..writeByte(2)
      ..write(obj.long);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UploadStatusAdapter extends TypeAdapter<UploadStatus> {
  @override
  final int typeId = 3;

  @override
  UploadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UploadStatus.uploading;
      case 1:
        return UploadStatus.uploaded;
      case 2:
        return UploadStatus.failed;
      default:
        return UploadStatus.uploading;
    }
  }

  @override
  void write(BinaryWriter writer, UploadStatus obj) {
    switch (obj) {
      case UploadStatus.uploading:
        writer.writeByte(0);
        break;
      case UploadStatus.uploaded:
        writer.writeByte(1);
        break;
      case UploadStatus.failed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UploadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
