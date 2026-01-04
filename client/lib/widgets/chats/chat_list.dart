import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/theme/app_typography.dart';

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
        ),
      ],
    );
  }
}
