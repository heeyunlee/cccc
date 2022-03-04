import 'package:shared_preferences/shared_preferences.dart';

/// A class that builds upon [SharedPreferences] package to get, update, or remove
/// stored data.
///
class SharedPreferencesService {
  /// Get `key` instance from [SharedPreferences]. You need to specify the type
  /// of the desired key's instance.
  Future<T?> get<T>(String key, Type type) async {
    final prefs = await SharedPreferences.getInstance();

    switch (type) {
      case int:
        return prefs.getInt(key) as T?;
      case double:
        return prefs.getDouble(key) as T?;
      case bool:
        return prefs.getBool(key) as T?;
      case String:
        return prefs.getString(key) as T?;
      case List<String>:
        return prefs.getStringList(key) as T?;
      default:
        return prefs.getString(key) as T?;
    }
  }

  /// Update `key` instance to [SharedPreferences] with following [value]
  Future<bool> update<T>(String key, T value) async {
    final prefs = await SharedPreferences.getInstance();

    switch (value.runtimeType) {
      case int:
        return await prefs.setInt(key, value as int);
      case double:
        return await prefs.setDouble(key, value as double);
      case bool:
        return await prefs.setBool(key, value as bool);
      case String:
        return await prefs.setString(key, value as String);
      case List<String>:
        return await prefs.setStringList(key, value as List<String>);
      default:
        return await prefs.setString(key, value as String);
    }
  }

  /// Remove `key` instance from [SharedPreferences]. The function returns the
  /// boolean value of whether the remove was successful or not.
  Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final remove = await prefs.remove(key);

    return remove;
  }
}
