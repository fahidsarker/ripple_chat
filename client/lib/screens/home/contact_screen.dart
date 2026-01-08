import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/users_provider.dart';
import 'package:ripple_client/widgets/users/user_avatar.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersRes = ref.watch(userListProvider());
    if (usersRes.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (usersRes.hasError) {
      return Center(child: Text('Error: ${usersRes.error}'));
    }
    final users = usersRes.value!;
    return Row(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Card(
            key: const Key('contact_list_card'),
            child: Center(
              child: ListView(
                children: [
                  for (var user in users)
                    ListTile(
                      leading: UserAvatar(
                        imgUrl: user.profilePhotoUrl,
                        uid: user.id,
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
