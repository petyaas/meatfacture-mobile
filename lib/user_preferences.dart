import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart/core/constants/shared_keys.dart';

class UserPreferences {
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._ctor();
  SharedPreferences _prefs;

  init() async {
    _prefs = UserPreferences().data;
  }

  get data {
    return _prefs.getString(SharedKeys.data) ?? '';
  }

  set data(String value) {
    _prefs.setString(SharedKeys.data, value);
  }

  get token {
    return _prefs.getString(SharedKeys.data) ?? '';
  }

  set token(String value) {
    _prefs.setString(SharedKeys.data, value);
  }
}
