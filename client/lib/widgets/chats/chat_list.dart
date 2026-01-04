import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/extensions/list.dart';
import 'package:ripple_client/providers/chat_provider.dart';

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatRes = ref.watch(chatListProvider());
    if (chatRes.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (chatRes.hasError) {
      return Center(child: Text('Error loading chats'));
    }
    final chats = chatRes.value?.multiple(30) ?? [];
    return Column(
      children: [
        Row(
          children: [
            Text('Chats', style: AppTypography.headlineLarge),
            Spacer(),
            IconButton(
              icon: Icon(FontAwesomeIcons.penToSquare),
              onPressed: () {
                context.go('/chat/new');
              },
            ),
          ],
        ),
        SizedBox(height: 16),
        CupertinoSearchTextField(
          placeholder: 'Search chats',
          prefixIcon: Icon(FontAwesomeIcons.magnifyingGlass),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chats.length,
            itemBuilder: (_, i) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text(
                    chats[i].title != null && chats[i].title!.isNotEmpty
                        ? chats[i].title![0].toUpperCase()
                        : 'U',
                  ),
                ),
                title: Text(chats[i].title ?? 'User'),
                subtitle: Text(chats[i].id),
                onTap: () {
                  context.go('/chat/${chats[i].id}');
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
