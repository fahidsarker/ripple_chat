import 'package:ripple_client/extensions/map.dart';
import 'package:ripple_client/models/message.dart';

class ChatMember {
  final String id;
  final String name;

  ChatMember({required this.id, required this.name});
}

class Chat {
  final String id;
  final String? title;
  final bool isGroup;

  final Message? lastMessage;

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
    required this.lastMessage,
    required this.members,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json.get('id'),
      title: json.get('title'),
      isGroup: json.get('isGroup'),
      lastMessage: json.getAndMap<Map<String, dynamic>?, Message?>(
        'lastMessage',
        (json) => json != null ? Message.fromJson(json) : null,
      ),
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
      'lastMessage': lastMessage?.toJson(),
      'members': members.map((e) => {'id': e.id, 'name': e.name}).toList(),
    };
  }

  String? get lastMessageSenderContent {
    if (lastMessage == null) {
      return null;
    }
    return "${lastMessage!.sender.name}: ${lastMessage!.content}";
  }
}
