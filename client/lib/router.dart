import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/screens/auth/login-screen.dart';
import 'package:ripple_client/screens/auth/registration_screen.dart';
import 'package:ripple_client/screens/init/connect-server.dart';
import 'package:ripple_client/screens/welcome.dart';

final globalRouteHistory = <String>[];

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/connect-server',
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(path: '/welcome', builder: (_, __) => WelcomeScreen()),
      GoRoute(path: '/registration', builder: (_, __) => RegistrationScreen()),
      GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
      GoRoute(
        path: '/connect-server',
        builder: (_, __) => ConnectServerScreen(),
      ),
    ],
  );
});
