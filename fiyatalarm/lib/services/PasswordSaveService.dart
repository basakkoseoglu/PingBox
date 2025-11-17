import 'package:shared_preferences/shared_preferences.dart';

class PasswordSaveService {
  static const _keyEmail = "savedEmail";
  static const _keyPassword = "savedPassword";
  static const _keyAccepted = "passwordSaveAccepted"; // 🔥 EKLENEN FLAG

  static Future<void> saveLoginInfo({
    required String email,
    String? password,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_keyEmail, email);

    if (password != null) {
      await prefs.setString(_keyPassword, password);

      // 🔥 Şifre kaydetmeyi kabul etti → bir daha popup gösterilmesin
      await prefs.setBool(_keyAccepted, true);
    } else {
      await prefs.remove(_keyPassword);
    }
  }

  /// 🔥 Popup'ı gösterip göstermeyeceğini belirlemek için
  static Future<bool> isAcceptedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAccepted) ?? false;
  }

  static Future<Map<String, String?>> loadSavedInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "email": prefs.getString(_keyEmail),
      "password": prefs.getString(_keyPassword),
    };
  }
}
