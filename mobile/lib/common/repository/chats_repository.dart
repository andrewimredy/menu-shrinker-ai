import 'package:cached_resource/cached_resource.dart';
import 'package:injectable/injectable.dart';

import '../common.dart';

@singleton
class ChatsRepository extends CachedResource<String, List<Chat>> {
  ChatsRepository()
      : super.persistent(
          'chats',
          decode: (json) => Chat.fromJsonList(json),
          cacheDuration: const CacheDuration.neverStale(),
        );
}
