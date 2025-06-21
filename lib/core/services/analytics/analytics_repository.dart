import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';
import 'package:intelligenz/models/analytics_response.dart';
import 'package:intelligenz/providers/dio_provider.dart';

class AnalyticsRepository {
  final Box<AnalyticsModel> _analyticsBox = Hive.box<AnalyticsModel>(
    analyticsBox,
  );

  Future<void> setSelectedAnalytics(AnalyticsModel model) async {
    await _analyticsBox.put(selectedAnalyticsKey, model);
  }

  Future<List<AnalyticsList>> getAnalytics() async {
    final dio = await DioProvider().client;
    try {
      final response = await dio.get('/api/v1/analytics/list');

      final analyticsResponse = AnalyticsResponse.fromJson(response.data);
      return analyticsResponse.data?.analyticsList ?? [];
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isAnalyticsSelected() async {
    return _analyticsBox.containsKey(selectedAnalyticsKey);
  }

  Future<AnalyticsModel?> getSelectedAnalytics() async {
    return _analyticsBox.get(selectedAnalyticsKey);
  }

  /// Just the hashId (if needed)
  Future<String?> getSelectedHashId() async {
    return _analyticsBox.get(selectedAnalyticsKey)?.hashId;
  }

  /// Just the name (if needed)
  Future<String?> getSelectedAnalyticsName() async {
    return _analyticsBox.get(selectedAnalyticsKey)?.analyticsName;
  }

  /// Clear selected analytic
  Future<void> clearSelectedAnalytics() async {
    await _analyticsBox.delete(selectedAnalyticsKey);
  }
}
