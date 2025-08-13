import 'package:dio/dio.dart';

class DioClient {

  DioClient({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 10),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );
  final Dio _dio;

  Future<Response> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Options? options,
  }) async => await _dio.post(
      url,
      data: data,
      options: options?.copyWith(headers: headers) ?? Options(headers: headers),
    );
}
