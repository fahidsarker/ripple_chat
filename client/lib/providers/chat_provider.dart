import 'package:resultx/resultx.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/chat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_provider.g.dart';

@riverpod
Future<List<Chat>> chatList(
  Ref ref, {
  int? limit,
  int? offset,
  String? search,
}) async {
  return await ref.api
      .get<Map<String, dynamic>>('/api/chats')
      .mapSuccess((d) => d['chats'] as List<dynamic>)
      .mapSuccess((d) => d.map((d) => Chat.fromJson(d)).toList())
      .getOrThrow();
}
