// import 'package:just_audio/just_audio.dart';
import 'package:fodie_ai/common/router/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';
// import 'package:speech_to_text/speech_to_text.dart';

@module
abstract class ThirdPartyModule {
  GoRouter get router => GoRouter(
    routes: $appRoutes,
    redirect: redirect,
    initialLocation: '/home',
  );

  Logger get logger => Logger();

  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker();

  GoogleSignIn get googleSignIn => GoogleSignIn(scopes: ['email']);

  GoogleAuthProvider get googleAuthProvider => GoogleAuthProvider();

  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  // FirebaseStorage get firebaseStorage => FirebaseStorage.instance;

  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  InAppPurchase get inAppPurchase => InAppPurchase.instance;
}
