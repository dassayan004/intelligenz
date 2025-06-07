import 'dart:convert';

import 'package:intelligenz/core/services/data/secure_storage_service.dart';
import 'package:intelligenz/models/login_response.dart';
import 'package:intelligenz/models/user_model.dart';
import 'package:intelligenz/providers/dio_provider.dart';

class AuthRepository {
  final SecureStorageService _storageService = SecureStorageService();

  Future<void> setUrl(String url) async {
    await _storageService.save('apiUrl', url);
  }

  Future<String?> getUrl() async {
    return await _storageService.read('apiUrl');
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

      await _storageService.save('auth_token', tenantUserLogin.token);
      await _storageService.save(
        'user',
        jsonEncode(tenantUserLogin.user.toJson()),
      );
      return tenantUserLogin;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storageService.delete('auth_token');
    await _storageService.delete('user');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storageService.read('auth_token');
    return token != null && token.isNotEmpty;
  }

  Future<String?> getToken() async {
    return await _storageService.read('auth_token');
  }

  Future<User?> getUser() async {
    final userJson = await _storageService.read('user');
    if (userJson == null) return null;
    try {
      return User.fromJson(jsonDecode(userJson));
    } catch (e) {
      rethrow;
    }
  }
}
