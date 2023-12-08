import 'package:shared_preferences/shared_preferences.dart';

class CacheData {
  SharedPreferences? sharedPreferences;
  

  // Future<bool> isLogedin(
  //     {required String email, required String password}) async {
  //   sharedPreferences = await SharedPreferences.getInstance();
  //   await sharedPreferences!.setString('email', email);
  //   await sharedPreferences!.setString('password', password);
  //   return true;
  // }


  void setEmail({required String email}) async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('email', email);
  }

  void setPassword({required String password}) async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('password', password);
  }

  void removeEmail() async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.remove('email');
  }
  void removePassword() async{
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.remove('password');
  }

  Future<String?> getEmail() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences?.getString('email');
  }

  Future<String?> getPassword() async{
    sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences?.getString('password');
  }
}
