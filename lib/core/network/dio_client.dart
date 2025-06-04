import 'package:dio/dio.dart';

class DioClient {
  final Dio _dio;

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  Future<Response> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) async {
    return await _dio.post(
      url,
      data: data,
      options: Options(headers: headers),
    );
  }
}
