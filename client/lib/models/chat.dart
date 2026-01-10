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

  ChatMember? opponentMember(String uid) =>
      isGroup ? null : members.where((member) => member.id != uid).firstOrNull;

  String validTitle(String currentUserId) {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }
    if (isGroup) {
      return "Group Chat";
    } else {
      final opponent = opponentMember(currentUserId);
      return opponent?.name ?? "User";
    }
  }

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

  Chat copyWith({
    String? id,
    String? title,
    bool? isGroup,
    Message? lastMessage,
    List<ChatMember>? members,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      isGroup: isGroup ?? this.isGroup,
      lastMessage: lastMessage ?? this.lastMessage,
      members: members ?? this.members,
    );
  }

  String? get lastMessageSenderContent {
    if (lastMessage == null) {
      return null;
    }
    return "${lastMessage!.sender.name}: ${lastMessage!.content}";
  }
}
