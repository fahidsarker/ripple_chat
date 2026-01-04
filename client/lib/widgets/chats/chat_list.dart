import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/providers/chat_provider.dart';
import 'package:ripple_client/providers/state_provider.dart';
import 'package:ripple_client/widgets/paginated_list_view.dart';

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
        Expanded(child: ChatListView()),
      ],
    );
  }
}

class ChatListView extends ConsumerWidget {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
      itemCount: chats.length,
      hasMore: chatResNotifier.hasMore,
      isLoadingMore: chatResNotifier.isLoadingMore,
      onLoadMore: chatResNotifier.nextPage,
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
    );
  }
}
