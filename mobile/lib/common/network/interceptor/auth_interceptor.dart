import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

@injectable
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = /*dotenv.env['API_KEY']*/ 'sk-do-lBFKHiVHwGitShYUPD1wW8VKbnV4d1OP9c1iIfzP-Gme86UL9Xs7HxbPEd';
    
    if (apiKey != null) {
      options.headers['Authorization'] = 'Bearer $apiKey';
    }
    
    super.onRequest(options, handler);
  }
}