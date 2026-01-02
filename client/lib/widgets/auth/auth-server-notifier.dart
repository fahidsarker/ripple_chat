import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/api_provider.dart';
import 'package:ripple_client/widgets/ui/consume.dart';

class AuthFormServerNotifier extends StatelessWidget {
  const AuthFormServerNotifier({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: context.c.border, height: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'You are logging into',
                style: AppTypography.labelLarge.copyWith(
                  color: context.c.textSecondary,
                ),
              ),
            ),
            Expanded(child: Divider(color: context.c.border, height: 1)),
          ],
        ),

        // Social Login Buttons
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Consume(
              provider: baseApiRouteProvider,
              builder: (_, t) => Text(
                t ?? 'No server connected',
                style: AppTypography.buttonLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.c.success,
                ),
              ),
            ),
            const SizedBox(width: 4),
            TextButton(
              onPressed: () {
                context.go('/connect-server');
              },
              child: Row(
                children: [
                  Icon(Icons.edit, size: 16, color: context.c.primaryLight),
                  const SizedBox(width: 4),
                  Text(
                    'Update',
                    style: AppTypography.buttonMedium.copyWith(
                      color: context.c.primaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
