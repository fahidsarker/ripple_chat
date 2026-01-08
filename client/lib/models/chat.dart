import 'package:ripple_client/extensions/map.dart';

class ChatMember {
  final String id;
  final String name;

  ChatMember({required this.id, required this.name});
}

class Chat {
  final String id;
  final String? title;
  final bool isGroup;

  final String? lastMessageContent;
  final String? lastMessageSenderName;
  final String? lastMessageSenderId;

  final List<ChatMember> members;

  String? opponentMemberId(String uid) => isGroup
      ? null
      : members
            .where((member) => member.id != uid)
            .map((member) => member.id)
            .firstOrNull;

  Chat({
    required this.id,
    required this.title,
    required this.isGroup,
    this.lastMessageContent,
    this.lastMessageSenderName,
    this.lastMessageSenderId,
    required this.members,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json.get('id'),
      title: json.get('title'),
      isGroup: json.get('isGroup'),
      lastMessageContent: json.get('lastMessageContent'),
      lastMessageSenderName: json.get('lastMessageSenderName'),
      lastMessageSenderId: json.get('lastMessageSenderId'),
      members: (json.get<List<dynamic>?>('members') ?? [])
          .map((e) => ChatMember(id: e['id'], name: e['name']))
          .toList(),
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
      'members': members.map((e) => {'id': e.id, 'name': e.name}).toList(),
    };
  }

  String? get lastMessageSenderContent {
    if (lastMessageSenderName != null && lastMessageContent != null) {
      return '${lastMessageSenderName!}: ${lastMessageContent!}';
    }
    return lastMessageContent;
  }
}
