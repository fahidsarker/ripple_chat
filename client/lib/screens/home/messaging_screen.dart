import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/state_provider.dart';
import 'package:ripple_client/widgets/ui/consume.dart';

final messageContentStateProvider = StateProvider.of<String>('');

class MessagingScreen extends ConsumerWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Spacer(),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            Expanded(child: MessageInputArea()),
            Consume(
              provider: messageContentStateProvider,
              builder: (_, v) {
                if (v.isNotEmpty) {
                  return IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.paperPlane,
                      color: context.c.primary,
                    ),
                  );
                }
                return Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.file),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
                    IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class MessageInputArea extends ConsumerWidget {
  const MessageInputArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      onChanged: (v) =>
          ref.read(messageContentStateProvider.notifier).state = v,
      decoration: InputDecoration(
        hintText: 'Type a message...',
        isDense: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
    );
  }
}
