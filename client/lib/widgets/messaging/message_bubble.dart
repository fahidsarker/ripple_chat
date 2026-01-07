import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/models/message.dart';

class MessageBubble extends ConsumerWidget {
  final String currentUserId;
  final Message message;
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSentByCurrentUser = message.senderId == currentUserId;
    return Row(
      children: [
        if (isSentByCurrentUser) Spacer(),
        Container(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSentByCurrentUser
                ? context.c.primary
                : context.c.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            message.content,
            style: TextStyle(
              color: isSentByCurrentUser
                  ? context.c.onPrimary
                  : context.c.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
