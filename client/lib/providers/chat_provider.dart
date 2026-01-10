import 'package:flutter/material.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/chat.dart';
import 'package:ripple_client/models/message.dart';
import 'package:ripple_client/providers/socket_io_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_provider.g.dart';

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
    listenToNewChats();
    listenToNewChatUpdates();
    final chats = await fetchChats(offset);
    if (chats.length < (pageSize)) {
      hasMore.value = false;
    }
    return chats;
  }

  void listenToNewChats() {
    final socket = ref.watch(rippleSocketProvider);
    socket?.subscribeToNewChatCreations((data) {
      final newChat = Chat.fromJson(data);
      state = AsyncValue.data([newChat, ...state.value ?? []]);
    });
  }

  void listenToNewChatUpdates() {
    final socket = ref.watch(rippleSocketProvider);
    socket?.subscribeToChatUpdates((data) async {
      try {
        final lastmessage = Message.fromJson(data);
        final chatId = lastmessage.chatId;
        final currentChats = state.value ?? [];
        final chatIndex = currentChats.indexWhere((chat) => chat.id == chatId);
        if (chatIndex != -1) {
          final chat = currentChats.removeAt(chatIndex);
          final updatedChat = chat.copyWith(lastMessage: lastmessage);
          state = AsyncValue.data([updatedChat, ...currentChats]);
        } else {
          final fetchedChat = await ref.read(
            chatDetailProvider(chatId: chatId).future,
          );
          state = AsyncValue.data([
            fetchedChat.copyWith(lastMessage: lastmessage),
            ...currentChats,
          ]);
        }
      } catch (e) {
        // Handle error if necessary
      }
    });
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

@riverpod
Future<Chat> chatDetail(Ref ref, {required String chatId}) async {
  return await ref.api
      .get<Map<String, dynamic>>(ApiGet.chatOf.path(chatId: chatId))
      .mapSuccess((d) => Chat.fromJson(d['chat']))
      .getOrThrow();
}
