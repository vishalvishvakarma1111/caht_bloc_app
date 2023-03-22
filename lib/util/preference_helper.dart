import 'package:shared_preferences/shared_preferences.dart';

enum PrefTypes { bool, string, int, double }

class PreferenceHelper {
  static const String isLogin = "is_login";

  SharedPreferences? sharedPreferences;
  static final PreferenceHelper _singleton = PreferenceHelper._internal();

  PreferenceHelper._internal();

  static PreferenceHelper instance() => _singleton;

  Future<SharedPreferences> getSharedPrefs() async => sharedPreferences ??= await SharedPreferences.getInstance();

  Future<void> setPreference(String key, dynamic value, PrefTypes type) async {
    switch (type) {
      case PrefTypes.bool:
        await getSharedPrefs().then((sp) => sp.setBool(key, value));
        break;
      case PrefTypes.int:
        await getSharedPrefs().then((sp) => sp.setInt(key, value));
        break;
      case PrefTypes.double:
        await getSharedPrefs().then((sp) => sp.setDouble(key, value));
        break;
      case PrefTypes.string:
        await getSharedPrefs().then((sp) => sp.setString(key, value));
        break;
    }
  }

  Future<dynamic> getPreference(String key, PrefTypes type) async {
    switch (type) {
      case PrefTypes.bool:
        return await getSharedPrefs().then((sp) => sp.getBool(key)) ?? false;
      case PrefTypes.int:
        return await getSharedPrefs().then((sp) => sp.getInt(key)) ?? 0;
      case PrefTypes.double:
        return await getSharedPrefs().then((sp) => sp.getDouble(key)) ?? 0.0;
      case PrefTypes.string:
        return await getSharedPrefs().then((sp) => sp.getString(key)) ?? "";
    }
  }

  void clearPreference() {
    sharedPreferences!.clear();
  }
}
