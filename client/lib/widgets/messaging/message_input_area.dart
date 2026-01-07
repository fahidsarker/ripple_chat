import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/extensions/map.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/screens/home/messaging_screen.dart';
import 'package:ripple_client/widgets/ui/consume.dart';

class MessageInputArea extends HookConsumerWidget {
  final String chatId;
  const MessageInputArea({super.key, required this.chatId});

  Future<bool> sendMessage(BuildContext context, WidgetRef ref) async {
    final text = ref.read(messageContentStateProvider);
    final res = await ref.api.post(
      ApiPost.messages.path(chatId: chatId),
      body: {'content': text}.toFormData(),
    );
    return res.isSuccess;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatController = useTextEditingController();
    final focusNode = useFocusNode();
    return Row(
      children: [
        IconButton(onPressed: () {}, icon: Icon(Icons.add)),
        Expanded(
          child: TextField(
            focusNode: focusNode,
            controller: chatController,
            onChanged: (v) =>
                ref.read(messageContentStateProvider.notifier).state = v,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
          ),
        ),
        Consume(
          provider: messageContentStateProvider,
          builder: (_, v) {
            if (v.isNotEmpty) {
              return IconButton(
                onPressed: () async {
                  if (await sendMessage(context, ref)) {
                    chatController.clear();
                    ref.read(messageContentStateProvider.notifier).state = '';
                    focusNode.requestFocus();
                  }
                },
                icon: Icon(
                  FontAwesomeIcons.paperPlane,
                  color: context.c.primary,
                ),
              );
            }
            return Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.file)),
                IconButton(onPressed: () {}, icon: Icon(Icons.camera_alt)),
                IconButton(onPressed: () {}, icon: Icon(Icons.mic)),
              ],
            );
          },
        ),
      ],
    );
  }
}
