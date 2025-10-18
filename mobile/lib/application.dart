import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../common/common.dart';

class Application extends StatelessWidget {
  const Application(this.routerConfig, {super.key});

  final RouterConfig<Object> routerConfig;

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 781),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [Locale('en', 'US')],
        child: DevicePreview(
          enabled: false,
          builder: (context) => _App(navigatorKey: navigatorKey, routerConfig: routerConfig),
        ),
      ),
    );
  }
}

class _App extends StatelessWidget {
  const _App({required this.navigatorKey, required this.routerConfig});

  final GlobalKey<NavigatorState> navigatorKey;
  final RouterConfig<Object> routerConfig;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      key: navigatorKey,
      routerConfig: routerConfig,
      darkTheme: ThemeData(
        iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
            iconColor: WidgetStateProperty.all(buttonGreyColor),
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
        ),
        colorScheme: const ColorScheme(
          brightness: Brightness.light,

          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Color(0xFF8E8E93),
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
      ),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return LoadingOverlayScope(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
