class Chat {
  final String id;
  final String? title;
  final bool isGroup;

  Chat({required this.id, required this.title, required this.isGroup});

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(id: json['id'], title: json['title'], isGroup: json['isGroup']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'isGroup': isGroup};
  }
}
