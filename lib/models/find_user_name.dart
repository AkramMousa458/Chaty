import 'package:akram/models/user.dart';

String findUserName(List<User> list, String email) {
  for (int i = 0; i < list.length; i++) {
    if (list[i].email == email) {
      return list[i].name;
    }
  }
  return 'not found';
}
