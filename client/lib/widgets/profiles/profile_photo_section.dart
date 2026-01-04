import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/widgets/profiles/profile_section.dart';

class ProfilePhotoSection extends ConsumerWidget {
  const ProfilePhotoSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProfileSection(
      icon: Icons.account_circle_outlined,
      title: 'Profile Photo',
      child: Center(
        child: Column(
          children: [
            // Profile Photo Placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.c.primary.wOpacity(0.1),
                border: Border.all(color: context.c.border, width: 2),
              ),
              child: Icon(Icons.person, size: 60, color: context.c.primary),
            ),
            const SizedBox(height: 16),
            // Photo Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.showSnackBar('Photo upload coming soon!');
                  },
                  icon: const Icon(Icons.upload),
                  label: const Text('Upload'),
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  onPressed: () {
                    context.showSnackBar('Photo removed');
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
