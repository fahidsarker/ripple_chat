import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/extensions/map.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/utils/merged_notififer.dart';
import 'package:ripple_client/widgets/ui/consume.dart';

class MessageInputArea extends ConsumerStatefulWidget {
  final String chatId;
  const MessageInputArea({super.key, required this.chatId});

  @override
  ConsumerState<MessageInputArea> createState() => _MessageInputAreaState();
}

class _MessageInputAreaState extends ConsumerState<MessageInputArea> {
  final TextEditingController chatController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final ValueNotifier<String> messageContent = ValueNotifier('');
  final ValueNotifier<List<XFile>> selectedMedias = ValueNotifier([]);
  late final canSendNotifier = Merged2Notififer(
    messageContent,
    selectedMedias,
    (content, medias) => content.isNotEmpty || medias.isNotEmpty,
  );

  @override
  void dispose() {
    chatController.dispose();
    focusNode.dispose();
    messageContent.dispose();
    super.dispose();
  }

  Future<void> selectMedia() async {
    final images = await ImagePicker().pickMultipleMedia(
      limit: 10,
      imageQuality: 80,
    );
    if (images.isNotEmpty) {
      selectedMedias.value = images;
    }
  }

  Future<bool> sendMessage() async {
    final text = messageContent.value.trim();
    final res = await ref.api
        .post(
          ApiPost.messages.path(chatId: widget.chatId),
          body: {'content': text}.toFormData(),
        )
        .onSuccess((_) {
          chatController.clear();
          messageContent.value = '';
          focusNode.requestFocus();
        });
    return res.isSuccess;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConsumeNotifier(
          notifier: selectedMedias,
          builder: (context, medias) {
            return SizedBox.shrink();
            // return Wrap(
            // children: [for (final media in medias) XFilePreview(file: media)],
            // );
          },
        ),
        Row(
          children: [
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
            Expanded(
              child: TextField(
                focusNode: focusNode,
                controller: chatController,
                onChanged: (v) => messageContent.value = v,
                onSubmitted: (value) async {
                  await sendMessage();
                },
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            ConsumeNotifier(
              notifier: canSendNotifier,
              builder: (_, canSend) {
                if (canSend) {
                  return IconButton(
                    onPressed: sendMessage,
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
                    IconButton(
                      onPressed: selectMedia,
                      icon: Icon(Icons.camera_alt),
                    ),
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
