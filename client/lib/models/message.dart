import 'package:ripple_client/extensions/map.dart';

class Message {
  final String id;
  final DateTime createdAt;
  final String chatId;
  final String content;
  final MessageSender sender;
  final List<MessageAttachment> attachments;

  Message({
    required this.id,
    required this.createdAt,
    required this.chatId,
    required this.content,
    required this.sender,
    required this.attachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json.get('id'),
      createdAt: DateTime.parse(json.get('createdAt')),
      chatId: json.get('chatId'),
      sender: MessageSender(
        id: json.get('senderId'),
        name: json.get('senderName'),
      ),
      content: json.get('content'),
      attachments: (json.get<List<dynamic>>(
        'attachments',
      )).map((e) => MessageAttachment.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'chatId': chatId,
      'senderId': sender.id,
      'senderName': sender.name,
      'content': content,
      'attachments': attachments.map((e) => e.toJson()).toList(),
    };
  }
}

class MessageSender {
  final String id;
  final String name;

  MessageSender({required this.id, required this.name});

  factory MessageSender.fromJson(Map<String, dynamic> json) {
    return MessageSender(id: json.get('id'), name: json.get('name'));
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class MessageAttachment {
  final String id;
  final String originalName;
  final String ext;

  MessageAttachment({
    required this.id,
    required this.originalName,
    required this.ext,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json.get('id'),
      originalName: json.get('originalName'),
      ext: json.get('ext'),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'originalName': originalName, 'ext': ext};
  }
}
