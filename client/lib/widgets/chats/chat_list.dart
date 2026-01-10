import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/providers/chat_provider.dart';
import 'package:ripple_client/providers/state_provider.dart';
import 'package:ripple_client/widgets/paginated_list_view.dart';
import 'package:ripple_client/widgets/users/user_avatar.dart';

final _chatQueryState = StateProvider.of('');

class ChatList extends ConsumerWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          onChanged: (q) => ref.read(_chatQueryState.notifier).debounceSet(q),
        ),
        SizedBox(height: 16),
        Expanded(child: ChatListView()),
      ],
    );
  }
}

class ChatListView extends ConsumerWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final selectedChatId = context.router.pathParameters['cid'];
    final query = ref.watch(_chatQueryState).toLowerCase();
    final provider = chatListProvider(search: query);
    final chatResNotifier = ref.watch(provider.notifier);
    final chatRes = ref.watch(provider);

    if (chatRes.hasError) {
      return Center(child: Text('Error loading chats'));
    }

    if (chatRes.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final chats = chatRes.value ?? [];

    if (chats.isEmpty) {
      return Center(child: Text('No chats found'));
    }

    return PaginatedListView(
      key: PageStorageKey('chat_list_view'),
      itemCount: chats.length,
      hasMore: chatResNotifier.hasMore,
      isLoadingMore: chatResNotifier.isLoadingMore,
      onLoadMore: chatResNotifier.nextPage,
      itemBuilder: (_, i) {
        final opponentMember = chats[i].opponentMember(auth?.user.id ?? '');

        return ListTile(
          leading: opponentMember == null
              ? CircleAvatar(
                  child: Text(
                    chats[i]
                            .validTitle(auth?.user.id ?? '')
                            .characters
                            .firstOrNull
                            ?.toUpperCase() ??
                        '?',
                  ),
                )
              : UserAvatar(uid: opponentMember.id),
          title: Text(chats[i].validTitle(auth?.user.id ?? '')),
          subtitle: Row(
            children: [
              Expanded(
                child: Text(chats[i].lastMessageSenderContent ?? 'New Chat'),
              ),
            ],
          ),
          selected: chats[i].id == selectedChatId,
          selectedColor: context.c.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          selectedTileColor: context.c.textSecondary.wOpacity(0.1),
          onTap: () {
            context.go('/chat/${chats[i].id}');
          },
        );
      },
    );
  }
}
