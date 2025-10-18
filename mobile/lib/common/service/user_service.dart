import 'dart:async';

import 'package:cached_repository/cached_repository.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../common.dart';

@injectable
class UserService {
  UserService({
    required UserRepository userRepository,
    required UserApi userApi,
    required GoogleSignIn googleSignIn,
    required FirebaseAuth firebaseAuth,
  }) : _userRepository = userRepository,
       _userApi = userApi,
       _googleSignIn = googleSignIn,
       _firebaseAuth = firebaseAuth;

  final UserApi _userApi;
  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  /// Get the user or login with Provider if the user is not logged in.
  Future<Resource<User?>> getUser({SignInProvider? signInProvider}) async =>
      _userRepository.getUser(signInProvider: signInProvider);

  Stream<Resource<User?>> getUserStream() => _userRepository.getUserStream();

  Future<void> invalidate() => _userRepository.invalidate();

  Future<void> updateUser({
    String? email,
    String? name,
    String? accountName,
    DateTime? premiumUntil,
    bool? pureMode,
  }) async {
    final user = (await getUser()).data;
    if (user == null) throw Exception('Could not fetch user');



    final newUser = user.copyWith(
      email: email ?? user.email,
      accountName: accountName ?? user.accountName,
    );

    await Future.wait([_userApi.updateUser(newUser), _userRepository.updateValue(newUser)]);
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    await _userRepository.clear();
  }

  Future<void> deleteUser() async {
    final user = (await getUser()).data;
    if (user == null) throw Exception('Could not fetch user');

    _userApi.deleteUser(user);
    _userRepository.clear();
  }
}
