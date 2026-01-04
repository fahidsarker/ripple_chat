import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:ripple_client/screens/error_screen.dart';

class Toolbar extends HookConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expanded = useState(false);
    final currentPath = GoRouterState.of(context).fullPath ?? 'xx';

    final auth = ref.watch(authProvider);
    if (auth == null) {
      return const ErrorScreen();
    }

    final toolbarItems = [
      (title: 'Chats', icon: Icons.chat_bubble, href: '/chat', onClick: null),
      (title: 'Calls', icon: Icons.call, href: '/calls', onClick: null),
      (
        title: 'Contacts',
        icon: Icons.contacts,
        href: '/contacts',
        onClick: null,
      ),
      (title: 'Files', icon: Icons.folder, href: '/files', onClick: null),
      (title: '_', icon: Icons.more_horiz, href: null, onClick: null),
      (title: 'Settings', icon: Icons.settings, href: null, onClick: null),
      (
        title: auth.user.name,
        icon: Icons.person,
        href: '/profile',
        onClick: null,
      ),
      (
        title: expanded.value ? 'Collapse' : 'Expand',
        icon: expanded.value
            ? FontAwesomeIcons.angleLeft
            : FontAwesomeIcons.angleRight,
        href: null,
        onClick: () {
          expanded.value = !expanded.value;
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in toolbarItems)
          if (item.title == '_')
            const Spacer()
          else if (expanded.value)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: context.c.textSecondary,
                backgroundColor: currentPath.contains(item.href ?? 'zz')
                    ? context.c.textSecondary.wOpacity(0.2)
                    : Colors.transparent,
              ),
              onPressed: () {
                if (item.onClick != null) {
                  item.onClick!();
                }
                if (item.href != null) {
                  context.go(item.href!);
                }
              },
              child: SizedBox(
                width: 120,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(item.icon),
                    const SizedBox(width: 8),
                    Text(item.title),
                  ],
                ),
              ),
            )
          else
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: currentPath.contains(item.href ?? 'zz')
                    ? context.c.textSecondary.wOpacity(0.2)
                    : Colors.transparent,
                foregroundColor: context.c.textSecondary,
              ),
              icon: Icon(item.icon),
              tooltip: item.title,
              onPressed: () {
                if (item.onClick != null) {
                  item.onClick!();
                }
                if (item.href != null) {
                  context.go(item.href!);
                }
              },
            ),
      ],
    );
  }
}
