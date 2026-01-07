import 'package:ripple_client/extensions/map.dart';

class Message {
  final String id;
  final DateTime createdAt;
  final String senderId;
  final String content;
  final MessageSender sender;
  final List<MessageAttachment> attachments;

  Message({
    required this.id,
    required this.createdAt,
    required this.senderId,
    required this.content,
    required this.sender,
    required this.attachments,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json.get('id'),
      createdAt: DateTime.parse(json.get('createdAt')),
      senderId: json.get('senderId'),
      content: json.get('content'),
      sender: MessageSender.fromJson(json.get<Map<String, dynamic>>('sender')),
      attachments: (json.get<List<dynamic>>(
        'attachments',
      )).map((e) => MessageAttachment.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'senderId': senderId,
      'content': content,
      'sender': sender.toJson(),
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
  final String relativePath;
  final String originalName;
  final String ext;

  MessageAttachment({
    required this.id,
    required this.relativePath,
    required this.originalName,
    required this.ext,
  });

  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json.get('id'),
      relativePath: json.get('relativePath'),
      originalName: json.get('originalName'),
      ext: json.get('ext'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'relativePath': relativePath,
      'originalName': originalName,
      'ext': ext,
    };
  }
}
