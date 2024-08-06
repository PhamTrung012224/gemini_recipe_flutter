import 'dart:developer';

import 'package:dio/dio.dart';

class DioProvider {
  final String baseUrl;
  final Map<String, dynamic>? header;
  late final Dio _dio;

  DioProvider({required this.baseUrl, this.header}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: header,
    ));
  }

  Future<Map<String, dynamic>> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _dio.get(path, queryParameters: queryParameters);
      if (res.statusCode != null &&
          (res.statusCode! >= 200 || res.statusCode! <= 299)) {
        return res.data ?? {};
      }
      return {};
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
