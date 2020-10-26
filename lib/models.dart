class User {
  User({this.username, this.email, this.password, this.is_staff});

  final String username;
  final String email;
  final String password;
  final bool is_staff;

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'is_staff': is_staff,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(username: json['username'], email: json['email'], password: json['password'], is_staff: json['is_staff']);
  }
}

class LoginUser {
  final String username;
  final String password;

  LoginUser({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(username: json['username'], password: json['password']);
  }
}

class DeviceInfo {
  final int user;
  final String name;
  final String android_uuid;
  // final String manufacturer;

  DeviceInfo({this.user, this.name, this.android_uuid});

  Map<String, dynamic> toJson() {
    return {'user': user, 'name': name, 'android_uuid': android_uuid};
  }
}
