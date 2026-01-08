import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/models/message.dart';
import 'package:ripple_client/widgets/users/user_avatar.dart';

class MessageBubble extends ConsumerWidget {
  final String currentUserId;
  final Message message;
  final bool isPreviousFromSameUser;
  final bool isNextFromSameUser;
  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    required this.isPreviousFromSameUser,
    required this.isNextFromSameUser,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSentByCurrentUser = message.senderId == currentUserId;
    const avatarSize = 18.0;
    const borderRadius = 12.0;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isSentByCurrentUser) Spacer(),
          if (!isSentByCurrentUser) ...[
            if (!isPreviousFromSameUser)
              UserAvatar(uid: message.senderId, size: avatarSize)
            else
              SizedBox(width: avatarSize),
            SizedBox(width: 8),
          ],
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSentByCurrentUser
                  ? context.c.primary
                  : context.c.background,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(borderRadius),
                topRight: Radius.circular(borderRadius),
                bottomRight: isSentByCurrentUser
                    ? Radius.circular(borderRadius)
                    : Radius.circular(borderRadius),
                bottomLeft: isSentByCurrentUser
                    ? Radius.circular(borderRadius)
                    : isPreviousFromSameUser
                    ? Radius.circular(borderRadius)
                    : Radius.circular(0),
              ),
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
      ),
    );
  }
}
