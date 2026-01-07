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
      id: json['id'],
      title: json['title'],
      isGroup: json['isGroup'],
      lastMessageContent: json['lastMessageContent'],
      lastMessageSenderName: json['lastMessageSenderName'],
      lastMessageSenderId: json['lastMessageSenderId'],
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
