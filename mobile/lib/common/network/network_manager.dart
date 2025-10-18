import 'package:dio/dio.dart';

class NetworkManager {
  NetworkManager._();

  static Dio getApiDioClient({required Uri baseUrl, List<Interceptor> interceptors = const []}) =>
      _getDioClient(baseUrl: baseUrl, interceptors: interceptors);

  static Dio _getDioClient({
    required Uri baseUrl,
    Duration connectTimeout = const Duration(seconds: 30),
    Duration receiveTimeout = const Duration(seconds: 30),
    Duration sendTimeout = const Duration(seconds: 30),
    List<Interceptor> interceptors = const [],
    String? contentType,
  }) {
    final options = BaseOptions(
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      sendTimeout: sendTimeout,
      contentType: contentType,
    )..baseUrl = baseUrl.toString();

    final dio = Dio(options);

    dio.interceptors.addAll(interceptors);

    return dio;
  }
}
