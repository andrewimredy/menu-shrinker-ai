import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:http_parser/http_parser.dart';

@injectable
class AIChatApi {
  final Dio _dio;
  
  AIChatApi(this._dio);
  
  Future<dynamic> suggestMenuItems({
    required List<File> menuPhotos,
    required List<String> preferences,
  }) async {
    try {
      final formData = FormData();
      
      // Add preferences
      for (final preference in preferences) {
        formData.fields.add(MapEntry('preferences', preference));
      }
      
      // Add menu photos
      for (int i = 0; i < menuPhotos.length; i++) {
        final file = menuPhotos[i];
        final fileName = 'menu_page${i + 1}.jpg';
        
        formData.files.add(MapEntry(
          'menu_photos',
          await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
      }
      
      final response = await _dio.post(
        'http://138.68.252.92:5000/suggest',
        data: formData,
        options: Options(
          responseType: ResponseType.plain,
        ),
      );
      
      // Return the raw text response
      return response.data;
    } catch (e) {
      throw Exception('Failed to get menu suggestions: $e');
    }
  }
}