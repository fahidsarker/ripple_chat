// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
final authProvider = AuthProvider._();

final class AuthProvider extends $NotifierProvider<Auth, AuthData?> {
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthData? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthData?>(value),
    );
  }
}

String _$authHash() => r'f3aafbe5bd01e853130a7b0b6cfd020a731fbbb6';

abstract class _$Auth extends $Notifier<AuthData?> {
  AuthData? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthData?, AuthData?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthData?, AuthData?>,
              AuthData?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
