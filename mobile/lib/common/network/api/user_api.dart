import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../common.dart' as common;

@injectable
abstract class UserApi {
  @factoryMethod
  factory UserApi(
    GoogleSignIn googleSignIn,
    GoogleAuthProvider googleAuthProvider,
    FirebaseFirestore firestore,
    FirebaseAuth firebaseAuth,
  ) =>
      common.FakeApi.login.isEnabled
          ? FakeUserApi()
          : _FirebaseUserApi(googleSignIn, googleAuthProvider, firestore, firebaseAuth);

  Future<common.User> loginWithGoogle();

  Future<common.User> loginWithApple();

  Future<void> updateUser(common.User newUser);

  Future<void> deleteUser(common.User user);
}

class _FirebaseUserApi implements UserApi {
  _FirebaseUserApi(this.googleSignIn, this.googleAuthProvider, this.firestore, this.firebaseAuth);

  final GoogleSignIn googleSignIn;
  final GoogleAuthProvider googleAuthProvider;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  @override
  Future<common.User> loginWithGoogle() async {
    final account = await googleSignIn.signIn();

    if (account == null) {
      throw Exception('User cancelled login');
    }

    final auth = await account.authentication;

    final credential = GoogleAuthProvider.credential(accessToken: auth.accessToken, idToken: auth.idToken);

    final userCredential = await firebaseAuth.signInWithCredential(credential);

    final userUid = userCredential.user?.uid;
    if (userUid == null) {
      throw Exception('Failed to retrieve user ID from Firebase');
    }

    final document = firestore.collection(common.usersCollectionName).doc(userUid);
    final snapshot = await document.get();

    late common.User user;

    if (snapshot.exists) {
      user = common.User.fromJson(snapshot.data()!);
    } else {
      user = common.User(id: userUid, email: account.email, accountName: account.displayName);
      document.set(user.toJson());
    }

    return user;
  }

  @override
  Future<common.User> loginWithApple() async {
    // TODO Update Apple login, get email somehow
    // final credential = await apple.TheAppleSignIn.performRequests([
    //   const apple.AppleIdRequest(requestedScopes: [
    //     apple.Scope.email,
    //     apple.Scope.fullName,
    //   ])
    // ]);
    // final credential = await SignInWithApple.getAppleIDCredential(
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    // );
    //
    // final oAuthProvider = OAuthProvider('apple.com').credential(
    //   idToken: credential.identityToken,// String.fromCharCodes(credential.credential!.identityToken!),
    //   accessToken: credential.authorizationCode,
    // );

    //AppleAuthProvider is imported from the firebase_auth package
    var appleProvider = AppleAuthProvider();

    //shows native UI that asks user to show or hide their real email address
    appleProvider.addScope('email'); //this scope is required

    //pulls the user's full name from their Apple account
    appleProvider.addScope('name'); //this is not required

    final userCredential = await firebaseAuth.signInWithProvider(appleProvider);

    final userUid = userCredential.user?.uid;
    if (userUid == null) {
      throw Exception('Failed to retrieve user ID from Firebase');
    }

    final document = firestore.collection(common.usersCollectionName).doc(userUid);
    final snapshot = await document.get();

    late common.User user;

    if (snapshot.exists) {
      user = common.User.fromJson(snapshot.data()!);
    } else {
      user = common.User(id: userUid, email: userCredential.user?.email ?? '');
      document.set(user.toJson());
    }

    return user;
  }

  @override
  Future<void> updateUser(common.User newUser) async {
    final user = firebaseAuth.currentUser;

    final userUid = user?.uid;
    if (userUid == null) {
      throw Exception('Failed to retrieve user ID from Firebase');
    }

    final document = firestore.collection(common.usersCollectionName).doc(userUid);

    await document.set(newUser.toJson());
  }

  @override
  Future<void> deleteUser(common.User user) async {
    final document = firestore.collection(common.usersCollectionName).doc(user.id);
    await document.delete();

    final currentUser = firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
  }
}

class FakeUserApi implements UserApi {
  @override
  Future<common.User> loginWithGoogle() {
    // TODO: implement ping
    throw UnimplementedError();
  }

  @override
  Future<common.User> loginWithApple() {
    // TODO: implement loginWithApple
    throw UnimplementedError();
  }

  @override
  Future<void> updateUser(common.User newUser) {
    // TODO: implement setPremiumStatus
    throw UnimplementedError();
  }

  @override
  Future<void> deleteUser(common.User user) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }
}
