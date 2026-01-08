import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/widgets/chats/chat_list.dart';
import 'package:ripple_client/widgets/expanded_if.dart';

class ChatScreen extends ConsumerWidget {
  final Widget child;
  const ChatScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDetailedChild = context.router.fullPath != '/chat';
    return Row(
      children: [
        if (context.isWide || !hasDetailedChild) ...[
          Container(
            constraints: context.isWide
                ? BoxConstraints(maxWidth: 400, minWidth: 300)
                : null,
            child: ExpandedIf(
              expand: !context.isWide,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ChatList(key: const PageStorageKey('chat_list')),
                ),
              ),
            ),
          ),
          if (context.isWide) SizedBox(width: context.defPadding),
        ],
        if (hasDetailedChild || context.isWide)
          Expanded(
            flex: context.isUltraWide
                ? 4
                : context.isWide
                ? 3
                : 2,
            child: Card(child: child),
          ),
      ],
    );
  }
}
