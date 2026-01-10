import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/providers/message_provider.dart';
import 'package:ripple_client/widgets/messaging/message_bubble.dart';
import 'package:ripple_client/widgets/messaging/message_input_area.dart';
import 'package:ripple_client/widgets/messaging/message_screen_heading.dart';

class MessagingScreen extends StatelessWidget {
  final String chatId;
  const MessagingScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: MessageScreenHeading(chatId: chatId),
        ),
        SizedBox(height: 8),
        Expanded(child: MessageList(chatId: chatId)),
        SizedBox(height: 8),
        MessageInputArea(chatId: chatId),
      ],
    );
  }
}

class MessageList extends ConsumerWidget {
  final String chatId;
  const MessageList({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final messagesRes = ref.watch(messagesProvider(chatId: chatId));
    if (messagesRes.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (messagesRes.hasError) {
      return Center(child: Text('Error loading messages'));
    }
    final messages = messagesRes.value ?? [];
    return ListView.builder(
      reverse: true,
      itemBuilder: (_, index) {
        final message = messages[index];
        return MessageBubble(
          message: message,
          currentUserId: auth?.user.id ?? '',
          isPreviousFromSameUser:
              index > 0 && messages[index - 1].senderId == message.senderId,
          isNextFromSameUser:
              index < messages.length - 1 &&
              messages[index + 1].senderId == message.senderId,
        );
      },
      itemCount: messages.length,
    );
  }
}
