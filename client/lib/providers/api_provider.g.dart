// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BaseApiRoute)
final baseApiRouteProvider = BaseApiRouteProvider._();

final class BaseApiRouteProvider
    extends $NotifierProvider<BaseApiRoute, String?> {
  BaseApiRouteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'baseApiRouteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$baseApiRouteHash();

  @$internal
  @override
  BaseApiRoute create() => BaseApiRoute();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$baseApiRouteHash() => r'82b2fc8a9afec78b011361e256c0bdf42fd75771';

abstract class _$BaseApiRoute extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(dio)
final dioProvider = DioFamily._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._({
    required DioFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'dioProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @override
  String toString() {
    return r'dioProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    final argument = this.argument as String?;
    return dio(ref, authToken: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DioProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dioHash() => r'9cc8623b56d1bcab4bb561b8d2ea2aae993f91ab';

final class DioFamily extends $Family
    with $FunctionalFamilyOverride<Dio, String?> {
  DioFamily._()
    : super(
        retry: null,
        name: r'dioProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DioProvider call({String? authToken}) =>
      DioProvider._(argument: authToken, from: this);

  @override
  String toString() => r'dioProvider';
}

@ProviderFor(api)
final apiProvider = ApiProvider._();

final class ApiProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  ApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return api(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiHash() => r'c9d72636c94237fea461850700d0e99bcd10c691';
