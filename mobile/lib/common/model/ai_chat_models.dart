import 'dart:io';

class MenuSuggestionRequest {
  final List<File> menuPhotos;
  final List<String> preferences;

  MenuSuggestionRequest({
    required this.menuPhotos,
    required this.preferences,
  });
}

class MenuSuggestionResponse {
  final String responseText;
  final bool success;
  final List<MenuItemSuggestion>? suggestions;
  final List<String>? preferences;
  final int? menuItemsFound;
  final int? photosProcessed;
  final SuggestionData? suggestionData;

  MenuSuggestionResponse({
    required this.responseText,
    required this.success,
    this.suggestions,
    this.preferences,
    this.menuItemsFound,
    this.photosProcessed,
    this.suggestionData,
  });
  
  /// Returns only the message content for bubble display
  String get bubbleContent {
    if (suggestionData != null && 
        suggestionData!.choices.isNotEmpty && 
        suggestionData!.choices.first.message?.content != null) {
      return suggestionData!.choices.first.message!.content!;
    }
    return responseText;
  }

  factory MenuSuggestionResponse.fromText(String text) {
    return MenuSuggestionResponse(
      responseText: text,
      success: true,
    );
  }

  factory MenuSuggestionResponse.fromJson(dynamic json) {
    // Handle text response
    if (json is String) {
      return MenuSuggestionResponse.fromText(json);
    }
    
    // Handle JSON response
    if (json is Map<String, dynamic>) {
      final suggestions = <MenuItemSuggestion>[];
      
      // Parse the new format with AI suggestions
      SuggestionData? suggestionData;
      if (json['suggestion'] != null) {
        suggestionData = SuggestionData.fromJson(json['suggestion']);
        
        // Extract menu items from the content if available
        if (suggestionData.choices.isNotEmpty) {
          final firstChoice = suggestionData.choices.first;
          if (firstChoice.message?.content != null) {
            final content = firstChoice.message!.content!;
            
            // Extract menu items from the content
            final menuItems = _extractMenuItemsFromContent(content);
            suggestions.addAll(menuItems);
          }
        }
      }
      
      // Parse direct menu items if available
      if (json['menu_items'] != null && json['menu_items'] is List) {
        final menuItems = (json['menu_items'] as List)
            .map((item) => MenuItemSuggestion.fromJson(item))
            .toList();
        suggestions.addAll(menuItems);
      }
      
      // Parse preferences
      List<String>? preferences;
      if (json['preferences'] != null) {
        preferences = (json['preferences'] as List).map((e) => e.toString()).toList();
      }
      
      return MenuSuggestionResponse(
        responseText: json['message'] ?? '',
        success: json['success'] ?? true,
        suggestions: suggestions.isNotEmpty ? suggestions : null,
        preferences: preferences,
        menuItemsFound: json['menu_items_found'],
        photosProcessed: json['photos_processed'],
        suggestionData: suggestionData,
      );
    }
    
    // Fallback for unexpected response type
    return MenuSuggestionResponse(
      responseText: 'Unexpected response format',
      success: false,
    );
  }
  
  // Helper method to extract menu items from AI content
  static List<MenuItemSuggestion> _extractMenuItemsFromContent(String content) {
    final List<MenuItemSuggestion> items = [];
    
    // Simple regex to find numbered items like "1. **Item Name**"
    final RegExp itemRegex = RegExp(r'(\d+)\.\s+\*\*([^*]+)\*\*\s*\n([^*]+)');
    final matches = itemRegex.allMatches(content);
    
    for (final match in matches) {
      if (match.groupCount >= 3) {
        final name = match.group(2)?.trim() ?? '';
        final description = match.group(3)?.trim() ?? '';
        
        // Extract preferences from the description
        final preferences = <String>[];
        if (description.contains('high protein')) {
          preferences.add('high protein');
        }
        if (description.contains('low carb')) {
          preferences.add('low carb');
        }
        
        items.add(MenuItemSuggestion(
          name: name,
          description: description,
          matchingPreferences: preferences,
        ));
      }
    }
    
    return items;
  }
}

class SuggestionData {
  final List<Choice> choices;
  final int created;
  final String id;
  final String model;
  final String object;
  final Usage? usage;

  SuggestionData({
    required this.choices,
    required this.created,
    required this.id,
    required this.model,
    required this.object,
    this.usage,
  });

  factory SuggestionData.fromJson(Map<String, dynamic> json) {
    return SuggestionData(
      choices: (json['choices'] as List?)
          ?.map((e) => Choice.fromJson(e as Map<String, dynamic>))
          .toList() ?? [],
      created: json['created'] ?? 0,
      id: json['id'] ?? '',
      model: json['model'] ?? '',
      object: json['object'] ?? '',
      usage: json['usage'] != null ? Usage.fromJson(json['usage']) : null,
    );
  }
}

class Choice {
  final String? finishReason;
  final int index;
  final dynamic logprobs;
  final Message? message;

  Choice({
    this.finishReason,
    required this.index,
    this.logprobs,
    this.message,
  });

  factory Choice.fromJson(Map<String, dynamic> json) {
    return Choice(
      finishReason: json['finish_reason'],
      index: json['index'] ?? 0,
      logprobs: json['logprobs'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
    );
  }
}

class Message {
  final String? content;
  final String? reasoningContent;
  final String? refusal;
  final String role;

  Message({
    this.content,
    this.reasoningContent,
    this.refusal,
    required this.role,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      reasoningContent: json['reasoning_content'],
      refusal: json['refusal'],
      role: json['role'] ?? 'assistant',
    );
  }
}

class Usage {
  final int completionTokens;
  final int promptTokens;
  final int totalTokens;

  Usage({
    required this.completionTokens,
    required this.promptTokens,
    required this.totalTokens,
  });

  factory Usage.fromJson(Map<String, dynamic> json) {
    return Usage(
      completionTokens: json['completion_tokens'] ?? 0,
      promptTokens: json['prompt_tokens'] ?? 0,
      totalTokens: json['total_tokens'] ?? 0,
    );
  }
}

class MenuItemSuggestion {
  final String name;
  final String description;
  final List<String> matchingPreferences;
  final double? price;

  MenuItemSuggestion({
    required this.name,
    required this.description,
    required this.matchingPreferences,
    this.price,
  });

  factory MenuItemSuggestion.fromJson(Map<String, dynamic> json) {
    final matchingPreferences = <String>[];
    
    if (json['matching_preferences'] != null) {
      for (var pref in json['matching_preferences']) {
        matchingPreferences.add(pref.toString());
      }
    }
    
    return MenuItemSuggestion(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      matchingPreferences: matchingPreferences,
      price: json['price']?.toDouble(),
    );
  }
}