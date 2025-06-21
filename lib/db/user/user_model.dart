import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? firstname;

  @HiveField(2)
  String? lastname;

  @HiveField(3)
  String? email;

  @HiveField(4)
  String? userType;

  @HiveField(5)
  String? status;

  @HiveField(6)
  int? hasChangedPassword;

  User({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.userType,
    this.status,
    this.hasChangedPassword,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      userType: json['userType'],
      status: json['status'],
      hasChangedPassword: json['hasChangedPassword'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'userType': userType,
    'status': status,
    'hasChangedPassword': hasChangedPassword,
  };
}
