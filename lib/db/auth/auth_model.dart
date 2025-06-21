import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/db/user/user_model.dart';

part 'auth_model.g.dart';

@HiveType(typeId: 0)
class AuthModel extends HiveObject {
  @HiveField(0)
  String token;

  @HiveField(1)
  User user;

  AuthModel({required this.token, required this.user});
}
