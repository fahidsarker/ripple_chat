import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ripple_client/preferences.dart';
import 'package:ripple_client/providers/api_provider.dart';

class InitialRedirectScreen extends StatefulWidget {
  const InitialRedirectScreen({super.key});

  @override
  State<InitialRedirectScreen> createState() => _InitialRedirectScreenState();
}

class _InitialRedirectScreenState extends State<InitialRedirectScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!welcomeScreenShown.value) {
        return context.go('/welcome');
      }
      if (serverUriPref.value == null) {
        return context.go('/connect-server');
      }
      return context.go('/login');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
