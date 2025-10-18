import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/feature.dart';
import '../common.dart';

part 'app_router.g.dart';

bool _showPremium = false;

Future<String?> redirect(BuildContext context, GoRouterState state) async {
  return null;
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const LoginPage();
}

@TypedGoRoute<HomeRoute>(path: '/home', routes: [
  TypedGoRoute<DetailRoute>(path: 'detail'),
])
class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class DetailRoute extends GoRouteData {
  const DetailRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const DetailPage();
}

@TypedGoRoute<SettingRoute>(path: '/setting')
class SettingRoute extends GoRouteData {
  const SettingRoute({this.$extra});

  final User? $extra;

  @override
  Widget build(BuildContext context, GoRouterState state) => SettingPage(user: $extra!);
}
