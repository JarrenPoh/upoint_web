import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreference {
  static SharedPreferences? _preferences;

  static const _post = 'post';
  static const _form = 'form';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  //organizer create post
  static Future setpost(String post) async {
    print('存：$post');
    await _preferences?.setString(_post, post);
  }

  static Future removepost() async {
    await _preferences?.setString(_post, "");
  }

  static String getpost() {
    return _preferences?.getString(_post) ?? "";
  }

  //organizer create form
  static Future setform(String form) async {
    print('存：$form');
    await _preferences?.setString(_form, form);
  }

  static Future removeform() async {
    await _preferences?.setString(_form, "");
  }

  static String getform() {
    return _preferences?.getString(_form) ?? "";
  }
}
