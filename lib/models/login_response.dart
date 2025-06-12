import 'package:intelligenz/models/user_model.dart';

class LoginResponse {
  Data? data;
  Null errors;

  LoginResponse({this.data, this.errors});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['errors'] = errors;
    return data;
  }
}

class Data {
  TenantUserLogin? tenantUserLogin;

  Data({this.tenantUserLogin});

  Data.fromJson(Map<String, dynamic> json) {
    tenantUserLogin = json['tenantUserLogin'] != null
        ? TenantUserLogin.fromJson(json['tenantUserLogin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (tenantUserLogin != null) {
      data['tenantUserLogin'] = tenantUserLogin!.toJson();
    }
    return data;
  }
}

class TenantUserLogin {
  final String token;
  final User user;

  TenantUserLogin({required this.token, required this.user});

  factory TenantUserLogin.fromJson(Map<String, dynamic> json) {
    return TenantUserLogin(
      token: json['token'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['user'] = user.toJson();
    return data;
  }
}
