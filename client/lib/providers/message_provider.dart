import 'package:flutter/material.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/map.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/message.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'message_provider.g.dart';

@Riverpod(keepAlive: true)
class MessageList extends _$MessageList {
  int offset = 0;
  final ValueNotifier<bool> hasMore = ValueNotifier<bool>(true);
  final ValueNotifier<bool> isLoadingMore = ValueNotifier<bool>(false);

  MessageList();

  Future<List<Message>> fetchMessages(int offset) {
    return ref.api
        .get<Map<String, dynamic>>(
          ApiGet.messages.path(chatId: chatId),
          queryParameters: {
            'limit': pageSize,
            'offset': offset,
            if (search != null) 'search': search,
          },
        )
        .mapSuccess((d) => d.get<List<dynamic>>('messages'))
        .mapSuccess((d) => d.map((d) => Message.fromJson(d)).toList())
        .getOrThrow();
  }

  @override
  Future<List<Message>> build({
    int pageSize = 20,
    String? search,
    required String chatId,
  }) async {
    final messages = await fetchMessages(offset);
    if (messages.length < (pageSize)) {
      hasMore.value = false;
    }
    return messages;
  }

  Future<void> nextPage() {
    if (isLoadingMore.value || !hasMore.value) {
      return Future.value();
    }
    final newOffset = offset + (pageSize);
    isLoadingMore.value = true;
    return fetchMessages(newOffset)
        .then((messages) {
          offset = newOffset;
          state = AsyncValue.data([...state.value ?? [], ...messages]);
          if (messages.length < (pageSize)) {
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
