import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/db/auth/auth_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter/foundation.dart';

class DioProvider {
  static final DioProvider _instance = DioProvider._internal();
  factory DioProvider() => _instance;

  DioProvider._internal();

  Dio? _dio;

  Future<Dio> get client async {
    if (_dio != null) return _dio!;

    final metaBoxRef = Hive.box<String>(metaBox);
    final apiUrl = metaBoxRef.get(apiUrlKey) ?? '';

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
          final authBoxRef = Hive.box<AuthModel>(authBox);
          final auth = authBoxRef.get(authKey);

          if (auth != null && auth.token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer ${auth.token}';
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
