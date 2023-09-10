import 'package:shared_preferences/shared_preferences.dart';

class CacheDate {
  SharedPreferences? sharedPreferences;

  Future<bool> isLogedin(
      {required String email, required String password}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('email', email);
    await sharedPreferences!.setString('password', password);
    return true;
  }

  String? getEmail() {
    return sharedPreferences!.getString('email');
  }

  String? getPassword() {
    return sharedPreferences!.getString('password');
  }
}
