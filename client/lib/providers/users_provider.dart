import 'package:resultx/resultx.dart';
import 'package:ripple_client/core/api_paths.dart';
import 'package:ripple_client/extensions/riverpod.dart';
import 'package:ripple_client/models/user.dart';
import 'package:ripple_client/providers/api_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'users_provider.g.dart';

@riverpod
Future<List<User>> userList(
  Ref ref, {
  int? limit,
  int? offset,
  String? searchQuery,
}) async {
  final res = await ref
      .read(apiProvider)
      .get<Map<String, dynamic>>(
        ApiGet.users.path,
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
          if (searchQuery != null) 'search': searchQuery,
        },
      );

  return (res.getOrThrow()['users'] as List<dynamic>)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList();
}

@Riverpod(keepAlive: true)
Future<User> userDetail(Ref ref, {required String userId}) async {
  return await ref.api
      .get<Map<String, dynamic>>(ApiGet.userOf.path(userId: userId))
      .mapSuccess((u) => User.fromJson(u['user']))
      .getOrThrow();
}
