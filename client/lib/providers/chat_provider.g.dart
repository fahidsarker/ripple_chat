// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(chatList)
final chatListProvider = ChatListFamily._();

final class ChatListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Chat>>,
          List<Chat>,
          FutureOr<List<Chat>>
        >
    with $FutureModifier<List<Chat>>, $FutureProvider<List<Chat>> {
  ChatListProvider._({
    required ChatListFamily super.from,
    required ({int? limit, int? offset, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'chatListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatListHash();

  @override
  String toString() {
    return r'chatListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<Chat>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Chat>> create(Ref ref) {
    final argument =
        this.argument as ({int? limit, int? offset, String? search});
    return chatList(
      ref,
      limit: argument.limit,
      offset: argument.offset,
      search: argument.search,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ChatListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatListHash() => r'4f2c6df257b9af8abfe00e63111937c7d2faa053';

final class ChatListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Chat>>,
          ({int? limit, int? offset, String? search})
        > {
  ChatListFamily._()
    : super(
        retry: null,
        name: r'chatListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatListProvider call({int? limit, int? offset, String? search}) =>
      ChatListProvider._(
        argument: (limit: limit, offset: offset, search: search),
        from: this,
      );

  @override
  String toString() => r'chatListProvider';
}
