import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static String? getString(String key, {String? defValue}) {
    return _prefs.getString(key) ?? defValue;
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static int? getInt(String key, {int? defValue}) {
    return _prefs.getInt(key) ?? defValue;
  }

  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}