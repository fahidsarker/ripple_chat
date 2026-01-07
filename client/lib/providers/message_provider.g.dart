// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MessageList)
final messageListProvider = MessageListFamily._();

final class MessageListProvider
    extends $AsyncNotifierProvider<MessageList, List<Message>> {
  MessageListProvider._({
    required MessageListFamily super.from,
    required ({int pageSize, String? search, String chatId}) super.argument,
  }) : super(
         retry: null,
         name: r'messageListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messageListHash();

  @override
  String toString() {
    return r'messageListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  MessageList create() => MessageList();

  @override
  bool operator ==(Object other) {
    return other is MessageListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messageListHash() => r'389d71043e1e7718592c1a14e5931cef9dbeba1b';

final class MessageListFamily extends $Family
    with
        $ClassFamilyOverride<
          MessageList,
          AsyncValue<List<Message>>,
          List<Message>,
          FutureOr<List<Message>>,
          ({int pageSize, String? search, String chatId})
        > {
  MessageListFamily._()
    : super(
        retry: null,
        name: r'messageListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  MessageListProvider call({
    int pageSize = 20,
    String? search,
    required String chatId,
  }) => MessageListProvider._(
    argument: (pageSize: pageSize, search: search, chatId: chatId),
    from: this,
  );

  @override
  String toString() => r'messageListProvider';
}

abstract class _$MessageList extends $AsyncNotifier<List<Message>> {
  late final _$args =
      ref.$arg as ({int pageSize, String? search, String chatId});
  int get pageSize => _$args.pageSize;
  String? get search => _$args.search;
  String get chatId => _$args.chatId;

  FutureOr<List<Message>> build({
    int pageSize = 20,
    String? search,
    required String chatId,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Message>>, List<Message>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Message>>, List<Message>>,
              AsyncValue<List<Message>>,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(
        pageSize: _$args.pageSize,
        search: _$args.search,
        chatId: _$args.chatId,
      ),
    );
  }
}
