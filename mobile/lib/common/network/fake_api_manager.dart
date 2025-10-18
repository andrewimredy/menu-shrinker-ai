// ignore: unused_import
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../common.dart';

enum FakeApi {
  login,
  messages,
  subscriptions,
  tts,
  imageGen,
  characters,
  user;

  bool get isEnabled => FakeApiManager.isFakeApiEnabled(this);

  void setEnabled(bool enabled) => FakeApiManager.setFakeApiEnabled(this, enabled);
}

class FakeApiManager {
  static final _enabledFakeApi = <FakeApi>{
    // Place here fake api that should be enabled by default
    if (kDebugMode) FakeApi.messages,
    if (kDebugMode) FakeApi.subscriptions,
    if (kDebugMode) FakeApi.tts,
    if (kDebugMode) FakeApi.imageGen,
    if (kDebugMode) FakeApi.user,
  };

  static bool isFakeApiEnabled(FakeApi api) => _enabledFakeApi.contains(api);

  static void setFakeApiEnabled(FakeApi fakeApi, bool enabled) {
    getIt<Logger>().d('FakeAPI: setFakeApiEnabled: $fakeApi => $enabled');
    if (enabled) {
      _enabledFakeApi.add(fakeApi);
    } else {
      _enabledFakeApi.remove(fakeApi);
    }
  }
}
