import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ripple_client/screens/welcome.dart';

final globalRouteHistory = <String>[];

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/welcome',
    navigatorKey: rootNavigatorKey,
    routes: [GoRoute(path: '/welcome', builder: (_, __) => WelcomeScreen())],
  );
});
