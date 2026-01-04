import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/extensions/list.dart';
import 'package:ripple_client/extensions/results.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/providers/state_provider.dart';
import 'package:ripple_client/providers/users_provider.dart';

final _queryState = StateProvider.of('');
final _selectedUsersState = StateProvider.of<List<String>>([]);

class NewChatScreen extends HookConsumerWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create New Chat', style: AppTypography.headlineSmall),
        TextField(
          key: const Key('new_chat_title_field'),
          decoration: const InputDecoration(labelText: 'Chat Title (optional)'),
          controller: titleController,
        ),
        CupertinoSearchTextField(
          key: const Key('new_chat_search_field'),
          placeholder: 'Search contacts',
          onChanged: (q) => ref.read(_queryState.notifier).debounceSet(q),
        ),
        Expanded(child: UsersPickList()),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // if (kDebugMode)
            //   ElevatedButton(
            //     onPressed: () async {
            //       await ref.api
            //           .post<Map<String, dynamic>>(
            //             '/api/chats/create-dummy',
            //             body: {},
            //           )
            //           .mapSuccess((d) => d['chat']['id'] as String)
            //           .resolveWithUI(context)
            //           .onSuccess((d) => context.go('/chat/$d'));
            //     },
            //     child: const Text('Dummy Chats'),
            //   ),
            ElevatedButton(
              onPressed: () async {
                final selectedUsers = ref.read(_selectedUsersState);
                await ref.api
                    .post<Map<String, dynamic>>(
                      API_PATH_CHATS,
                      body: {
                        'title': titleController.text,
                        'memberIds': selectedUsers,
                        'isGroup': selectedUsers.length > 1,
                      },
                    )
                    .mapSuccess((d) => d['chat']['id'] as String)
                    .resolveWithUI(context)
                    .onSuccess((d) => context.go('/chat/$d'));
              },
              child: const Text('Create Chat'),
            ),
          ],
        ),
      ].withSeparator(const SizedBox(height: 12)),
    );
  }
}

class UsersPickList extends HookConsumerWidget {
  const UsersPickList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = ref.watch(_queryState);
    final maxLimit = useState(20);
    final usersListRes = ref.watch(
      userListProvider(limit: maxLimit.value, offset: 0, searchQuery: search),
    );

    if (usersListRes.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (usersListRes.hasError) {
      return Center(child: Text('Error: ${usersListRes.error}'));
    }

    final users = usersListRes.value ?? [];
    final selectedUsers = ref.watch(_selectedUsersState);
    return ListView.builder(
      itemCount: users.length + 1,
      itemBuilder: (context, index) {
        if (index == users.length) {
          if (users.length < maxLimit.value) {
            return const SizedBox.shrink();
          }
          return TextButton(
            onPressed: () {
              maxLimit.value += 20;
            },
            child: const Text('Load more'),
          );
        }
        final user = users[index];
        return CheckboxListTile(
          onChanged: (v) {
            final newUsers = List<String>.from(selectedUsers);
            if (v == true) {
              newUsers.add(user.id);
            } else {
              newUsers.remove(user.id);
            }
            ref.read(_selectedUsersState.notifier).state = newUsers;
          },
          value: selectedUsers.contains(user.id),
          title: Text(user.name, style: AppTypography.bodyMedium),
          subtitle: Text(user.email, style: AppTypography.bodySmall),
        );
      },
    );
  }
}
