// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnalyticsModelAdapter extends TypeAdapter<AnalyticsModel> {
  @override
  final int typeId = 2;

  @override
  AnalyticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsModel(
      hashId: fields[0] as String,
      analyticsName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.hashId)
      ..writeByte(1)
      ..write(obj.analyticsName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
