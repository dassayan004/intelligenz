import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/db/auth/auth_model.dart';
import 'package:intelligenz/db/user/user_model.dart';
import 'package:intelligenz/models/login_response.dart';

import 'package:intelligenz/providers/dio_provider.dart';

class AuthRepository {
  final Box<AuthModel> _authBox = Hive.box<AuthModel>(authBox);
  final Box<String> _metaBox = Hive.box<String>(metaBox); // for apiUrl
  Future<void> setUrl(String url) async {
    await _metaBox.put(apiUrlKey, url);
  }

  Future<void> setVideoLocationInterval(int timer) async {
    await _metaBox.put(videoIntervalKey, timer.toString());
  }

  Future<String?> getUrl() async {
    return _metaBox.get(apiUrlKey);
  }

  Future<int> getVideoLocationInterval() async {
    return int.parse(_metaBox.get(videoIntervalKey) ?? '');
  }

  Future<TenantUserLogin> login(String email, String password) async {
    const String loginMutation = r'''
      mutation tenantUserLogin($email: String!, $password: String!) {
        tenantUserLogin(email: $email, password: $password) {
          token
          user {
            id
            firstname
            lastname
            email
            userType
            status
            hasChangedPassword
          }
        }
      }
    ''';

    final dio = await DioProvider().client;
    try {
      final response = await dio.post(
        '/graphql',
        data: {
          'query': loginMutation,
          'variables': {'email': email, 'password': password},
        },
      );

      final responseData = response.data['data']['tenantUserLogin'];

      if (responseData == null) {
        throw Exception('Login failed: Invalid credentials or server error');
      }

      final tenantUserLogin = TenantUserLogin.fromJson(responseData);
      final authModel = AuthModel(
        token: tenantUserLogin.token,
        user: tenantUserLogin.user,
      );

      await _authBox.put(authKey, authModel);
      // await _storageService.save('auth_token', tenantUserLogin.token);
      // await _storageService.save(
      //   'user',
      //   jsonEncode(tenantUserLogin.user.toJson()),
      // );
      return tenantUserLogin;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _metaBox.delete(videoIntervalKey);
    await _metaBox.delete(apiUrlKey);
    await _authBox.delete(authKey);
  }

  Future<bool> isLoggedIn() async {
    final auth = _authBox.get(authKey);
    return auth?.token.isNotEmpty == true;
  }

  Future<String?> getToken() async {
    return _authBox.get(authKey)?.token;
  }

  Future<User?> getUser() async {
    return _authBox.get(authKey)?.user;
  }
}
