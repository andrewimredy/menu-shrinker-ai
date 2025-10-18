import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import '../../../common/service/ai_chat_service.dart';
import '../../../common/model/ai_chat_models.dart';
import 'ai_chat_state.dart';

@injectable
class AIChatCubit extends Cubit<AIChatState> {
  final AIChatService _aiChatService;

  AIChatCubit(this._aiChatService) : super(const AIChatState()) {
    _init();
  }

  void _init() {
    emit(state.copyWith(
      messages: [
        ChatMessage(
          text: 'I can help analyze your menu photos. What would you like to know?',
          isUser: false,
        ),
      ],
    ));
  }

  void setSelectedPhotos(List<XFile> photos) {
    emit(state.copyWith(selectedPhotos: photos));
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(text: text, isUser: true));

    emit(state.copyWith(
      messages: updatedMessages,
      status: AIChatStatus.loading,
    ));

    _getMenuSuggestions(text);
  }

  Future<void> _getMenuSuggestions(String userQuery) async {
    if (state.selectedPhotos == null || state.selectedPhotos!.isEmpty) {
      _addAIResponse('Please upload menu photos to analyze.');
      return;
    }

    try {
      // Extract preferences from user query
      final preferences = _extractPreferences(userQuery);
      
      final response = await _aiChatService.getMenuSuggestions(
        menuPhotos: state.selectedPhotos!,
        preferences: preferences,
      );

      if (response.success) {
        String responseText;
        
        // Check if we have suggestions from the AI response
        if (response.suggestions != null && response.suggestions!.isNotEmpty) {
          responseText = 'Here are menu items that match your preferences:';
          _addAIResponse(responseText, suggestions: response.suggestions);
        } else {
          // If no suggestions were extracted but we have a response message
          final aiContent = _extractAIContent(response);
          if (aiContent.isNotEmpty) {
            _addAIResponse(aiContent);
          } else {
            responseText = 'I couldn\'t find menu items matching your preferences.';
            _addAIResponse(responseText);
          }
        }
      } else {
        _addAIResponse('Sorry, I encountered an error');
      }
    } catch (e) {
      _addAIResponse('Sorry, something went wrong. Please try again.');
      emit(state.copyWith(
        status: AIChatStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
  
  // Extract the AI content from the response
  String _extractAIContent(MenuSuggestionResponse response) {
    // If we have a direct response text that's meaningful, use it
    if (response.responseText.isNotEmpty && 
        response.responseText != 'Menu suggestion generated') {
      return response.responseText;
    }
    
    // Try to extract content from the suggestion data
    try {
      if (response.suggestionData != null && 
          response.suggestionData!.choices.isNotEmpty &&
          response.suggestionData!.choices.first.message?.content != null) {
        return response.suggestionData!.choices.first.message!.content!;
      }
    } catch (e) {
      // If there's an error parsing the content, return empty
    }
    
    return '';
  }

  void _addAIResponse(String text, {List<MenuItemSuggestion>? suggestions}) {
    final updatedMessages = List<ChatMessage>.from(state.messages)
      ..add(ChatMessage(
        text: text,
        isUser: false,
        suggestions: suggestions,
      ));

    emit(state.copyWith(
      messages: updatedMessages,
      status: AIChatStatus.success,
    ));
  }

  List<String> _extractPreferences(String userQuery) {
    // Simple extraction based on common dietary preferences
    // In a real app, this could be more sophisticated with NLP
    final preferences = <String>[];
    final lowercaseQuery = userQuery.toLowerCase();
    
    final commonPreferences = [
      'vegan', 'vegetarian', 'gluten free', 'dairy free',
      'high protein', 'low carb', 'keto', 'paleo',
      'nut free', 'low fat', 'low calorie'
    ];
    
    for (final preference in commonPreferences) {
      if (lowercaseQuery.contains(preference)) {
        preferences.add(preference);
      }
    }
    
    // If no preferences detected, use the whole query
    if (preferences.isEmpty) {
      preferences.add(userQuery);
    }
    
    return preferences;
  }
}