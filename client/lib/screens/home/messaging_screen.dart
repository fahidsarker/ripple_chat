import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/providers/message_provider.dart';
import 'package:ripple_client/widgets/messaging/message_bubble.dart';
import 'package:ripple_client/widgets/messaging/message_input_area.dart';
import 'package:ripple_client/providers/state_provider.dart';

final messageContentStateProvider = StateProvider.of<String>('');

class MessagingScreen extends ConsumerWidget {
  final String chatId;
  const MessagingScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(child: MessageList(chatId: chatId)),
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
    final messagesRes = ref.watch(messageListProvider(chatId: chatId));
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
        );
      },
      itemCount: messages.length,
    );
  }
}
