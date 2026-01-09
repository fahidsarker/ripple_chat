import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:ripple_client/extensions/color.dart';
import 'package:ripple_client/models/message.dart';

class MessageContent extends StatelessWidget {
  final Message message;
  final TextStyle? textStyle;
  const MessageContent({super.key, required this.message, this.textStyle});

  @override
  Widget build(BuildContext context) {
    if (!message.content.contains(" ")) {
      // single word message, check for special types like gifs or stickers
      final url = Uri.tryParse(message.content);
      if (url != null && url.hasScheme) {
        if (url.host.contains("giphy.com")) {
          // Giphy link
          return Image.network(message.content, width: 250);
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message.content, style: textStyle),
              AnyLinkPreview(
                placeholderWidget: Container(),
                link: message.content,
                titleStyle: textStyle,
                backgroundColor: Colors.white.wOpacity(0.2),
                borderRadius: 12,
                errorWidget: Container(),
              ),
            ],
          );
        }
      }
      return Text(message.content, style: textStyle);
    }
    return Text(message.content, style: textStyle);
  }
}
