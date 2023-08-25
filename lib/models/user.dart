import '../constants.dart';

class User {
  final String email;
  final String name;

  User(this.email, this.name);

  factory User.fromJson(jsonData) {
    return User(jsonData[kEmail], jsonData[kName]);
  }
}
