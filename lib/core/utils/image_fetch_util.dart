import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ImageFetchUtil {
  /// Fetch image bytes from `/api/v1/images/fetch/<fileName>`
  static Future<Uint8List?> fetchImage(String fileName, Dio dio) async {
    try {
      final response = await dio.get<List<int>>(
        '/api/v1/images/fetch/$fileName',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Uint8List.fromList(response.data!);
      }
    } catch (e) {
      debugPrint('Error fetching image: $e');
      rethrow;
    }
    return null;
  }
}
