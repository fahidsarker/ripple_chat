import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ripple_client/providers/api_provider.dart';

extension RiverpodExt on WidgetRef {
  Dio get api => watch(apiProvider);
}
