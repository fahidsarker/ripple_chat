import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/client_conf.dart';
import 'package:ripple_client/models/server_conf.dart';
import 'package:ripple_client/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solid_shared_pref/solid_shared_pref.dart';
part 'api_provider.g.dart';

const serverConfPref = NullableStringPreference('server_conf');

@Riverpod(keepAlive: true)
class ApiConfig extends _$ApiConfig {
  @override
  ServerConf? build() {
    if (serverConfPref.value == null) {
      return null;
    }
    final conf = ServerConf.fromJsonString(serverConfPref.value!);

    if (conf != null) {
      connectServer(conf.httpUrl);
    }

    return conf;
  }

  Future<String?> connectServer(String urlStr) async {
    final url = Uri.tryParse(urlStr.trim());

    if (url == null) {
      return "Please enter a valid URL.";
    }

    try {
      final dio = Dio();
      final res = await dio.getUri(url.replace(path: '/ping'));

      if (res.statusCode == 200) {
        final data = res.data;
        if (data is Map<String, dynamic> && data['pong'] == true) {
          try {
            final config = ServerConf.fromJson(data);
            serverConfPref.value = jsonEncode(config.toJson());
            state = config;
            return null;
          } catch (e) {
            return "The server responded but with an invalid configuration.";
          }
        }
      }
      return "The server did not respond as expected. Please ensure it's a valid Ripple Chat server.";
    } catch (e) {
      return "Failed to connect to the server. Please check the URL and your internet connection.";
    }
  }
}

@riverpod
Dio dio(Ref ref, {String? authToken}) {
  final baseApiRoute = ref.watch(apiConfigProvider)?.httpUrl;
  final dio = Dio(BaseOptions(baseUrl: baseApiRoute ?? ''));
  if (authToken != null) {
    dio.options.headers['authorization'] = 'Bearer $authToken';
  }
  return dio;
}

@riverpod
Api api(Ref ref) {
  return Api(ref.watch(dioProvider(authToken: ref.watch(authProvider)?.token)));
}

@Riverpod(keepAlive: true)
Future<ClientConf?> clientConf(Ref ref) async {
  return ref.api
      .get<Map<String, dynamic>>('/api/client-config')
      .mapSuccess((d) => ClientConf.fromJson(d))
      .nullable()
      .resolve(onError: (_) => null)
      .data;
}
