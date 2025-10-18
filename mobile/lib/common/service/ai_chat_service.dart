import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:image_picker/image_picker.dart';
import '../model/ai_chat_models.dart';
import '../network/api/ai_chat_api.dart';

@injectable
class AIChatService {
  final AIChatApi _aiChatApi;
  
  AIChatService(this._aiChatApi);
  
  Future<MenuSuggestionResponse> getMenuSuggestions({
    required List<XFile> menuPhotos,
    required List<String> preferences,
  }) async {
    try {
      // Convert XFile to File
      final files = menuPhotos.map((xFile) => File(xFile.path)).toList();
      
      // Call API
      final response = await _aiChatApi.suggestMenuItems(
        menuPhotos: files,
        preferences: preferences,
      );
      
      // Parse response
      return MenuSuggestionResponse.fromJson(response);
    } catch (e) {
      return MenuSuggestionResponse(
        suggestions: null,
        responseText: 'Error: ${e.toString()}',
        success: false,
        preferences: preferences,
      );
    }
  }
}