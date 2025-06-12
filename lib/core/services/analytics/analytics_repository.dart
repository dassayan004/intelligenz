import 'package:intelligenz/core/services/data/secure_storage_service.dart';
import 'package:intelligenz/models/analytics_response.dart';
import 'package:intelligenz/providers/dio_provider.dart';

class AnalyticsRepository {
  static const _key = 'hash_id';
  final SecureStorageService _storageService = SecureStorageService();

  Future<void> setHashId(String id) async {
    await _storageService.save(_key, id);
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

  Future<bool> isHashSaved() async {
    final token = await _storageService.read(_key);
    return token != null && token.isNotEmpty;
  }

  Future<String?> getHashId() async {
    return await _storageService.read(_key);
  }

  Future<void> clearHashId() async {
    await _storageService.delete(_key);
  }
}
