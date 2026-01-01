import 'package:flutter/material.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
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
                      child: SingleChildScrollView(child: LoginForm()),
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
          image: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuA_mRgWyrKHn6R5ytFyG4k-gqblF_CYEX0g8zwFvZRaHJJ5Vh0fJkJeaqHDWXIcDyzE9QA2QpLFhxgLNELoFD8c9b9LabAL4Twsg7k_51RUj5ipm3hTe13Kr_EJiDCO5bTcO_kuvFyy7cTfGINyMFqhQ7Q6dmMSkSRS3tW3Rp5fNJp9-9cidUdG-Mx-p-8txhbngjau9JX-Pt5Of9h4OskDIqBbV0w_JivSysk-_Di4ooeyOxZfvuYCWPqgX7_DUKxuZ3WFnuFI0D4',
          ),
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
