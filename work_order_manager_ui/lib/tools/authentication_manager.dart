import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthenticationManager {
  static const String _prefsJwt = "auth-jwt";
  static const String _prefsExpirationDate = "auth-expirationdate";

  static Future setAuth(String? jwt, String? expirationDate) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefsJwt, jwt ?? "");
    prefs.setString(_prefsExpirationDate, expirationDate ?? "");
  }

  static Future clearAuth() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefsJwt, "");
    prefs.setString(_prefsExpirationDate, "");
  }

  static Future<String> getToken() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsJwt) ?? "";
  }

  static Future<String> getExpirationDate() async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(_prefsExpirationDate) ?? "";
  }
}
