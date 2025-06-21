import 'package:intelligenz/models/alert_response.dart';
import 'package:intelligenz/providers/dio_provider.dart';

class AlertRepository {
  Future<List<AlertData>> getAlertsFromAnalyticsName(
    String analyticsName,
  ) async {
    final dio = await DioProvider().client;
    try {
      final response = await dio.get(
        '/api/v1/alerts/get-alert-nvs/$analyticsName?cameraSelection=Mobile_Camera&selectedClasses=&page=1&sortOrder=desc',
        queryParameters: {'analyticsName': analyticsName},
      );
      if (response.statusCode == 200) {
        final alertResponse = AlertResponse.fromJson(response.data);
        return alertResponse.data ?? [];
      } else {
        throw Exception('Failed to load alerts');
      }
    } catch (e) {
      rethrow;
    }
  }
}
