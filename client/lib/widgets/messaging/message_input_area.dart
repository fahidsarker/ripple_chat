import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ripple_client/extensions/context.dart';
import 'package:ripple_client/providers/api_provider.dart';
import 'package:ripple_client/providers/message_provider.dart';
import 'package:ripple_client/utils/merged_notififer.dart';
import 'package:ripple_client/widgets/notified_visibility.dart';
import 'package:ripple_client/widgets/ui/consume.dart';
import 'package:giphy_picker/giphy_picker.dart';

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

  late final messageProvider = ref.read(
    messagesProvider(chatId: widget.chatId).notifier,
  );

  void sendMessage({String? content}) async {
    final text = content ?? messageContent.value.trim();
    final res = await messageProvider.sendMessage(content: text);
    if (res) {
      chatController.clear();
      messageContent.value = '';
      focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientConfig = ref.watch(clientConfProvider).value;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
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
              Expanded(
                child: TextField(
                  focusNode: focusNode,
                  controller: chatController,
                  onChanged: (v) => messageContent.value = v,
                  onSubmitted: (value) => sendMessage(),

                  decoration: InputDecoration(
                    suffixIcon: NotifiedVisibility(
                      reverse: true,
                      visibleNotifier: canSendNotifier,
                      child: clientConfig?.giphyApiKey == null
                          ? SizedBox.shrink()
                          : IconButton(
                              onPressed: () async {
                                final gif = await GiphyPicker.pickGif(
                                  context: context,
                                  apiKey: clientConfig!.giphyApiKey!,
                                  fullScreenDialog: false,
                                  showPreviewPage: false,
                                );

                                final gifUrl = gif?.images.original?.url;
                                if (gifUrl == null) return;
                                sendMessage(content: gifUrl);
                              },
                              icon: Icon(Icons.gif),
                            ),
                    ),
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
                      IconButton(onPressed: () {}, icon: Icon(Icons.folder)),
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
      ),
    );
  }
}
