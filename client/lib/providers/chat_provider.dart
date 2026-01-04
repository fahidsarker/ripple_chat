import 'package:flutter/material.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/chat.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_provider.g.dart';

// @riverpod
// Future<List<Chat>> chatList(
//   Ref ref, {
//   int? limit,
//   int? offset,
//   String? search,
// }) async {
//   return await ref.api
//       .get<Map<String, dynamic>>('/api/chats')
//       .mapSuccess((d) => d['chats'] as List<dynamic>)
//       .mapSuccess((d) => d.map((d) => Chat.fromJson(d)).toList())
//       .getOrThrow();
// }

@Riverpod(keepAlive: true)
class ChatList extends _$ChatList {
  int offset = 0;
  final ValueNotifier<bool> hasMore = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoadingMore = ValueNotifier<bool>(false);

  ChatList();

  Future<List<Chat>> fetchChats(int offset) {
    return ref.api
        .get<Map<String, dynamic>>(
          ApiGet.chats.path,
          queryParameters: {
            'limit': pageSize,
            'offset': offset,
            if (search != null) 'search': search,
          },
        )
        .mapSuccess((d) => d['chats'] as List<dynamic>)
        .mapSuccess((d) => d.map((d) => Chat.fromJson(d)).toList())
        .getOrThrow();
  }

  @override
  Future<List<Chat>> build({int pageSize = 20, String? search}) async {
    final chats = await fetchChats(offset);
    if (chats.length < (pageSize)) {
      hasMore.value = false;
    }
    return chats;
  }

  Future<void> nextPage() {
    if (isLoadingMore.value || !hasMore.value) {
      return Future.value();
    }
    final newOffset = offset + (pageSize);
    isLoadingMore.value = true;
    return fetchChats(newOffset)
        .then((chats) {
          offset = newOffset;
          state = AsyncValue.data([...state.value ?? [], ...chats]);
          if (chats.length < (pageSize)) {
            hasMore.value = false;
          }
        })
        .catchError((error, stackTrace) {
          state = AsyncValue.error(error, stackTrace);
        })
        .whenComplete(() {
          isLoadingMore.value = false;
        });
  }
}
