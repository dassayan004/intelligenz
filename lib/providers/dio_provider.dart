import 'package:dio/dio.dart';
import 'package:intelligenz/core/services/data/secure_storage_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class DioProvider {
  static final DioProvider _instance = DioProvider._internal();
  factory DioProvider() => _instance;

  DioProvider._internal();

  final SecureStorageService _storage = SecureStorageService();

  Dio? _dio;

  Future<Dio> get client async {
    if (_dio != null) return _dio!;

    final apiUrl = await _storage.read('apiUrl') ?? '';

    final dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptor to inject token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger());
    }

    _dio = dio;
    return _dio!;
  }
}
