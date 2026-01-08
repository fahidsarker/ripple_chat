import 'package:ripple_client/extensions/map.dart';

class Chat {
  final String id;
  final String? title;
  final bool isGroup;

  final String? lastMessageContent;
  final String? lastMessageSenderName;
  final String? lastMessageSenderId;

  Chat({
    required this.id,
    required this.title,
    required this.isGroup,
    this.lastMessageContent,
    this.lastMessageSenderName,
    this.lastMessageSenderId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json.get('id'),
      title: json.get('title'),
      isGroup: json.get('isGroup'),
      lastMessageContent: json.get('lastMessageContent'),
      lastMessageSenderName: json.get('lastMessageSenderName'),
      lastMessageSenderId: json.get('lastMessageSenderId'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isGroup': isGroup,
      'lastMessageContent': lastMessageContent,
      'lastMessageSenderName': lastMessageSenderName,
      'lastMessageSenderId': lastMessageSenderId,
    };
  }

  String? get lastMessageSenderContent {
    if (lastMessageSenderName != null && lastMessageContent != null) {
      return '${lastMessageSenderName!}: ${lastMessageContent!}';
    }
    return lastMessageContent;
  }
}
