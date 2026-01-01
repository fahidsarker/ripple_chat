import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:solid_shared_pref/solid_shared_pref.dart';
part 'auth_provider.g.dart';

// for now
// todo: implement secure storage
const authTokenPref = NullableStringPreference('auth_token');

@riverpod
class AuthToken extends _$AuthToken {
  @override
  String? build() {
    return authTokenPref.value;
  }

  set(String? token) {
    authTokenPref.value = token;
    state = token;
  }
}
