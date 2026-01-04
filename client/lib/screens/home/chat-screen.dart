import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';

class ChatScreen extends ConsumerWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        if (context.isWide)
          Expanded(
            flex: 2,
            child: Card(child: const Center(child: Text('Chat List'))),
          ),
        const SizedBox(width: 16),
        Expanded(
          flex: context.isUltraWide
              ? 4
              : context.isWide
              ? 3
              : 2,
          child: Card(child: const Center(child: Text('Chat Area'))),
        ),
      ],
    );
  }
}
