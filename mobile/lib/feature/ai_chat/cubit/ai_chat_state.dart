import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../common/model/ai_chat_models.dart';

enum AIChatStatus { initial, loading, success, error }

class ChatMessage {
  final String text;
  final bool isUser;
  final List<MenuItemSuggestion>? suggestions;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.suggestions,
  });
}

class AIChatState extends Equatable {
  final List<ChatMessage> messages;
  final List<XFile>? selectedPhotos;
  final AIChatStatus status;
  final String? errorMessage;

  const AIChatState({
    this.messages = const [],
    this.selectedPhotos,
    this.status = AIChatStatus.initial,
    this.errorMessage,
  });

  AIChatState copyWith({
    List<ChatMessage>? messages,
    List<XFile>? selectedPhotos,
    AIChatStatus? status,
    String? errorMessage,
  }) {
    return AIChatState(
      messages: messages ?? this.messages,
      selectedPhotos: selectedPhotos ?? this.selectedPhotos,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [messages, selectedPhotos, status, errorMessage];
}