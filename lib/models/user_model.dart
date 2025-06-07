class User {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? userType;
  String? status;
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

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    email = json['email'];
    userType = json['userType'];
    status = json['status'];
    hasChangedPassword = json['hasChangedPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['email'] = email;
    data['userType'] = userType;
    data['status'] = status;
    data['hasChangedPassword'] = hasChangedPassword;
    return data;
  }
}
