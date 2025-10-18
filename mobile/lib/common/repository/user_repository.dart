import 'package:cached_repository/cached_repository.dart';
import 'package:injectable/injectable.dart';

import '../common.dart';

@singleton
class UserRepository {
  UserRepository(UserApi userApi)
    : _cachedRepo = CachedRepository.persistent(
        'user',
        fetch: (key, [signInProvider]) {
          if (signInProvider == null) {
            return Future.value(null);
          }
          switch (signInProvider as SignInProvider) {
            case SignInProvider.apple:
              return userApi.loginWithApple();
            case SignInProvider.google:
              return userApi.loginWithGoogle();
          }
        },
        decode: (json) => User.fromJson(json),
        cacheDuration: const Duration(minutes: 15),
      );

  final CachedRepository<String, User?> _cachedRepo;

  Stream<Resource<User?>> getUserStream({bool forceReload = false, SignInProvider? provider}) =>
      _cachedRepo.stream('' /* you can add key */, forceReload: forceReload, fetchArguments: provider);

  Future<Resource<User?>> getUser({bool forceReload = false, SignInProvider? signInProvider}) =>
      _cachedRepo.first('' /* you can add key */, forceReload: forceReload, fetchArguments: signInProvider);

  Future<void> invalidate() => _cachedRepo.invalidate('' /* you can add key */);

  Future<void> clear() => _cachedRepo.clear();

  Future<void> updateValue(User newUser) => _cachedRepo.putValue('', newUser);
}
