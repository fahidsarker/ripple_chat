import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/providers/api_provider.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/providers/chat_provider.dart';
import 'package:ripple_client/widgets/users/user_avatar.dart';

class MessageScreenHeading extends ConsumerWidget {
  final String chatId;
  const MessageScreenHeading({super.key, required this.chatId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/chat');
                }
              },
              icon: Icon(Icons.arrow_back_ios),
            ),
            ...buildUi(context, ref),
          ],
        ),
      ),
    );
  }

  List<Widget> buildUi(BuildContext context, WidgetRef ref) {
    final detailRes = ref.watch(chatDetailProvider(chatId: chatId));
    final apiConfig = ref.watch(apiConfigProvider);
    final auth = ref.watch(authProvider);
    if (detailRes.isLoading) {
      return [Text('Loading...')];
    }
    if (detailRes.hasError) {
      return [Text('Error loading chat')];
    }
    final chat = detailRes.value;
    if (chat != null) {
      final opponentMember = chat.opponentMember(auth?.user.id ?? '');
      return [
        if (opponentMember != null)
          UserAvatar(uid: opponentMember.id)
        else
          CircleAvatar(
            child: Text(
              chat
                      .validTitle(auth?.user.id ?? '')
                      .characters
                      .firstOrNull
                      ?.toUpperCase() ??
                  '?',
            ),
          ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            chat.validTitle(auth?.user.id ?? ''),
            style: AppTypography.titleLarge,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (apiConfig?.allowsCalls ?? false) ...[
          IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.phone)),
          IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.video)),
        ],
        IconButton(onPressed: () {}, icon: FaIcon(Icons.more_horiz)),
      ];
    }
    return [];
  }
}
