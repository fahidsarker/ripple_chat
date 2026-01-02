import 'package:dio/dio.dart';
import 'package:ripple_client/core/api.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solid_shared_pref/solid_shared_pref.dart';
part 'api_provider.g.dart';

const serverUriPref = NullableStringPreference('server_uri');

@riverpod
class BaseApiRoute extends _$BaseApiRoute {
  @override
  String? build() {
    return serverUriPref.value;
  }

  set(String? uri) {
    serverUriPref.value = uri;
    state = uri;
  }
}

@riverpod
Dio dio(Ref ref, {String? authToken}) {
  final baseApiRoute = ref.watch(baseApiRouteProvider);
  final dio = Dio(BaseOptions(baseUrl: baseApiRoute ?? ''));
  if (authToken != null) {
    dio.options.headers['authorization'] = 'Bearer $authToken';
  }
  return dio;
}

@riverpod
Api api(Ref ref) {
  return Api(ref.watch(dioProvider(authToken: ref.watch(authTokenProvider))));
}
