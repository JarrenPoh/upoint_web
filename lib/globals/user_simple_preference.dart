import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;

  static const _post = 'post';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //Search Post History
  static Future setpost(String post) async {
    print('存：$post');
    await _preferences?.setString(_post, post);
  }

  static Future removepost(String post) async {
    await _preferences?.setString(_post, "");
  }

  static String getpost() {
    return _preferences?.getString(_post) ?? "";
  }
}
