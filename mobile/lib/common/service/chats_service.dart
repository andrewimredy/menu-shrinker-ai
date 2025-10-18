import 'dart:async';

import 'package:cached_resource/cached_resource.dart';
import 'package:injectable/injectable.dart';

import '../common.dart';

@injectable
class ChatsService {
  ChatsService({required ChatsRepository chatsRepository}) : _chatsRepository = chatsRepository;

  final ChatsRepository _chatsRepository;

  Future<void> updateChat({required Chat chat}) async {
    final chats = (await _chatsRepository.get('')).data?.toList() ?? [];
    final index = chats.indexWhere((element) => element.id == chat.id);
    if (index != -1) {
      chats[index] = chat;
    } else {
      chats.add(chat);
    }
    _chatsRepository.putValue('', chats);
  }

  Stream<Resource<List<Chat>>> getChatsStream() => _chatsRepository.asStream('');

  Stream<Chat?> getChatStream(chatId) =>
      getChatsStream().map((e) => e.data?.firstWhereOrNull((element) => element.id == chatId));

  Future<Chat?> getChat(String chatId) async {
    final resource = await _chatsRepository.get('');
    return resource.data?.firstWhereOrNull((element) => element.id == chatId);
  }
}
