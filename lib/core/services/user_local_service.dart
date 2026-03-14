import 'package:hive_flutter/hive_flutter.dart';

class UserLocalService {
  static const String _boxName = 'user_box';
  static const String _keyName = 'user_name';

  static Future<void> init() async {
    await Hive.openBox(_boxName);
  }

  /// Returns true if user has already set their name
  static bool hasUser() {
    final box = Hive.box(_boxName);
    final name = box.get(_keyName, defaultValue: '');
    return (name as String).trim().isNotEmpty;
  }

  /// Saves the user name
  static Future<void> saveName(String name) async {
    final box = Hive.box(_boxName);
    await box.put(_keyName, name.trim());
  }

  /// Returns the stored user name, or empty string
  static String getName() {
    final box = Hive.box(_boxName);
    return box.get(_keyName, defaultValue: '') as String;
  }
}
