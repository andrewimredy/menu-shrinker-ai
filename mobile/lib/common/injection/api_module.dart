// coverage:ignore-file
import 'package:fodie_ai/common/common.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class ApiModule {
  // @Named('mainDio')
  // Dio mainDio(
  //   Config config,
  //   BaseInterceptor baseInterceptor,
  //   LoggerInterceptor logInterceptor,
  //   ErrorInterceptor errorInterceptor,
  // ) => NetworkManager.getApiDioClient(
  //   baseUrl: config.baseUrl,
  //   interceptors: [baseInterceptor, logInterceptor, errorInterceptor],
  // );

  Dio dio(
    Config config,
    BaseInterceptor baseInterceptor,
    LoggerInterceptor logInterceptor,
    ErrorInterceptor errorInterceptor,
  ) => NetworkManager.getApiDioClient(
    baseUrl: config.aiApiUrl,
    interceptors: [baseInterceptor, logInterceptor, errorInterceptor],
  );
}
