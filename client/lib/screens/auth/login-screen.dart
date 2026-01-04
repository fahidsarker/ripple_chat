import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/extensions/results.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/widgets/login_form.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  // Future<bool> handleLogin(
  //   String email,
  //   String pass,
  //   BuildContext context,
  //   WidgetRef ref,
  // ) async {
  //   final res = await ref.api
  //       .post<Map<String, dynamic>>(
  //         API_PATH_LOGIN,
  //         body: {'email': email, 'password': pass},
  //       )
  //       .resolveWithUI(context);

  //   return res.when(
  //     success: (e) {
  //       ref.read(authTokenProvider.notifier).set(e['token'] as String);
  //       return e.containsKey('token');
  //     },
  //     error: (e) => false,
  //   );
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Row(
        children: [
          if (context.isWide) const Expanded(child: RippleChatLoginHeroArea()),
          Expanded(
            child: Container(
              color: context.c.background,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
              child: Column(
                children: [
                  if (!context.isWide) ...[
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: context.c.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.waves,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: LoginForm(
                          key: const Key('login_form'),
                          onLogin: (email, pass) async {
                            return await ref
                                .read(authProvider.notifier)
                                .login(email, pass);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RippleChatLoginHeroArea extends StatelessWidget {
  const RippleChatLoginHeroArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111418),
        image: const DecorationImage(
          image: AssetImage('assets/backgrounds/ripple.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.c.primary.wOpacity(0.1),
              const Color(0xFF101922).wOpacity(0.5),
              const Color(0xFF101922).wOpacity(0.9),
            ],
          ),
        ),
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Icon
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: context.c.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: context.c.primary.wOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.waves, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 24),
            // Headline
            Text(
              'Connect instantly.\nChat seamlessly.',
              style: AppTypography.displayMedium.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Text(
              'Experience the next generation of communication with Ripple Chat. Secure, fast, and built for connection.',
              style: AppTypography.bodyLarge.copyWith(
                color: const Color(0xFF93AEBF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
