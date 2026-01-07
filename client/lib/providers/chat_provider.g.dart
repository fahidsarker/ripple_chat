// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatList)
final chatListProvider = ChatListFamily._();

final class ChatListProvider
    extends $AsyncNotifierProvider<ChatList, List<Chat>> {
  ChatListProvider._({
    required ChatListFamily super.from,
    required ({int pageSize, String? search}) super.argument,
  }) : super(
         retry: null,
         name: r'chatListProvider',
         isAutoDispose: false,
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
  ChatList create() => ChatList();

  @override
  bool operator ==(Object other) {
    return other is ChatListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatListHash() => r'83fe3e6be017418e3eca594f3cc97aac37486dc9';

final class ChatListFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatList,
          AsyncValue<List<Chat>>,
          List<Chat>,
          FutureOr<List<Chat>>,
          ({int pageSize, String? search})
        > {
  ChatListFamily._()
    : super(
        retry: null,
        name: r'chatListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  ChatListProvider call({int pageSize = 20, String? search}) =>
      ChatListProvider._(
        argument: (pageSize: pageSize, search: search),
        from: this,
      );

  @override
  String toString() => r'chatListProvider';
}

abstract class _$ChatList extends $AsyncNotifier<List<Chat>> {
  late final _$args = ref.$arg as ({int pageSize, String? search});
  int get pageSize => _$args.pageSize;
  String? get search => _$args.search;

  FutureOr<List<Chat>> build({int pageSize = 20, String? search});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Chat>>, List<Chat>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Chat>>, List<Chat>>,
              AsyncValue<List<Chat>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(pageSize: _$args.pageSize, search: _$args.search),
    );
  }
}
