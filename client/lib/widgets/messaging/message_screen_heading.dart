import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';
import 'package:ripple_client/providers/chat_provider.dart';

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
    if (detailRes.isLoading) {
      return [Text('Loading...')];
    }
    if (detailRes.hasError) {
      return [Text('Error loading chat')];
    }
    final chat = detailRes.value;
    if (chat != null) {
      return [
        CircleAvatar(
          child: Text(
            chat.title != null && chat.title!.isNotEmpty
                ? chat.title![0].toUpperCase()
                : 'U',
          ),
        ),
        SizedBox(width: 8),
        Text(chat.title ?? 'Chat', style: AppTypography.titleLarge),
        Spacer(),
        IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.phone)),
        IconButton(onPressed: () {}, icon: FaIcon(FontAwesomeIcons.video)),
        IconButton(onPressed: () {}, icon: FaIcon(Icons.more_horiz)),
      ];
    }
    return [];
  }
}
