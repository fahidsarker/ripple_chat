import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/auth_provider.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('Chat Screen'),
            ElevatedButton(
              onPressed: () {
                ref.read(authTokenProvider.notifier).logout();
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
