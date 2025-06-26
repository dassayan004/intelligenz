import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:intelligenz/core/services/uploadForm/cubit/upload_form_cubit.dart';
import 'package:intelligenz/providers/dio_provider.dart';

class UploadRepository {
  Future uploadPhoto({
    required File file,
    required String analyticHashId,
    required String description,
    required int timestamp,
    required LatLong location,
  }) async {
    final dio = await DioProvider().client;
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'location': jsonEncode({
        'timestamp': timestamp,
        'lat': location.latitude,
        'long': location.longitude,
      }),
      'analytic_hash_id': analyticHashId,
      'description': description,
    });

    try {
      final resp = await dio.post('/api/v1/images/upload', data: formData);
      return resp.data;
    } catch (e) {
      rethrow;
    }
  }
}
