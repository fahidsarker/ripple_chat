// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(userList)
final userListProvider = UserListFamily._();

final class UserListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<User>>,
          List<User>,
          FutureOr<List<User>>
        >
    with $FutureModifier<List<User>>, $FutureProvider<List<User>> {
  UserListProvider._({
    required UserListFamily super.from,
    required ({int? limit, int? offset, String? searchQuery}) super.argument,
  }) : super(
         retry: null,
         name: r'userListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$userListHash();

  @override
  String toString() {
    return r'userListProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<List<User>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<User>> create(Ref ref) {
    final argument =
        this.argument as ({int? limit, int? offset, String? searchQuery});
    return userList(
      ref,
      limit: argument.limit,
      offset: argument.offset,
      searchQuery: argument.searchQuery,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is UserListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$userListHash() => r'46ac972cf1ee082a70a8606c746d2b0249eaeddb';

final class UserListFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<User>>,
          ({int? limit, int? offset, String? searchQuery})
        > {
  UserListFamily._()
    : super(
        retry: null,
        name: r'userListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  UserListProvider call({int? limit, int? offset, String? searchQuery}) =>
      UserListProvider._(
        argument: (limit: limit, offset: offset, searchQuery: searchQuery),
        from: this,
      );

  @override
  String toString() => r'userListProvider';
}
