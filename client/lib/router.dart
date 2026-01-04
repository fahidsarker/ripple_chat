import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/screens/auth/login-screen.dart';
import 'package:ripple_client/screens/auth/registration_screen.dart';
import 'package:ripple_client/screens/home/call-screen.dart';
import 'package:ripple_client/screens/home/chat-screen.dart';
import 'package:ripple_client/screens/home/contact-screen.dart';
import 'package:ripple_client/screens/home/files-screen.dart';
import 'package:ripple_client/screens/home/home-screen.dart';
import 'package:ripple_client/screens/home/profiles-screen.dart';
import 'package:ripple_client/screens/init/connect-server.dart';
import 'package:ripple_client/screens/init/init-redirect.dart';
import 'package:ripple_client/screens/welcome.dart';

final globalRouteHistory = <String>[];

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

class _RouterChangeNotifier extends ChangeNotifier {
  final Ref ref;

  _RouterChangeNotifier(this.ref) {
    ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = _RouterChangeNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: rootNavigatorKey,
    refreshListenable: routerNotifier,
    redirect: (context, state) {
      final authRes = ref.read(authProvider);
      if (authRes == null) {
        if (state.routeIn('/chat')) {
          return state.redirTo('/login');
        }
      } else if (state.routeIn(
        '/login',
        '/registration',
        '/welcome',
        '/connect-server',
      )) {
        return state.redirTo('/chat');
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => InitialRedirectScreen()),
      GoRoute(path: '/welcome', builder: (_, __) => WelcomeScreen()),
      GoRoute(path: '/registration', builder: (_, __) => RegistrationScreen()),
      GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
      GoRoute(
        path: '/connect-server',
        builder: (_, __) => ConnectServerScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeScreen(child: child),
        routes: [
          GoRoute(path: '/chat', builder: (_, __) => ChatScreen()),
          GoRoute(path: '/profile', builder: (_, __) => ProfileScreen()),
          GoRoute(path: '/files', builder: (_, __) => FilesScreen()),
          GoRoute(path: '/contacts', builder: (_, __) => ContactScreen()),
          GoRoute(path: '/calls', builder: (_, __) => CallScreen()),
        ],
      ),
    ],
  );
});

extension on GoRouterState {
  bool routeIn(
    String p1, [
    String? p2,
    String? p3,
    String? p4,
    String? p5,
    String? p6,
  ]) {
    final paths = [
      p1,
      if (p2 != null) p2,
      if (p3 != null) p3,
      if (p4 != null) p4,
      if (p5 != null) p5,
      if (p6 != null) p6,
    ];
    for (final path in paths) {
      if (matchedLocation.startsWith(path)) {
        return true;
      }
    }
    return false;
  }

  String? redirTo(String path) {
    if (routeIn(path)) {
      return null;
    }
    return path;
  }
}
