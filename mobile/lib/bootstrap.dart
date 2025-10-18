import 'dart:async';

import 'package:cached_resource/cached_resource.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:fodie_ai/firebase_options.dart';
import 'package:logger/logger.dart';
import 'package:resource_storage_hive/resource_storage_hive.dart';

import 'common/common.dart';

Future<void> bootstrap({
  required Widget Function(RouterConfig<Object> routerConfig) builder,
  bool isDebug = kDebugMode,
}) async => runZonedGuarded(() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ResourceConfig.setup(
    persistentStorageFactory: const HiveResourceStorageProvider(),
  );

  await configureDependencies();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(builder(getIt<GoRouter>()));
}, (Object error, StackTrace stackTrace) => print(error));
