import 'package:hive_flutter/hive_flutter.dart';

part 'analytics_model.g.dart';

@HiveType(typeId: 2)
class AnalyticsModel extends HiveObject {
  @HiveField(0)
  String hashId;

  @HiveField(1)
  String analyticsName;

  AnalyticsModel({required this.hashId, required this.analyticsName});
}
