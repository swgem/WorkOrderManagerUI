import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class AuthenticationManager {
  static const String _prefsJwt = "auth-jwt";
  static const String _prefsExpirationDate = "auth-expirationdate";

  static Future setAuth(String? jwt, String? expirationDate) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: _prefsJwt, value: jwt ?? "");
    await storage.write(key: _prefsExpirationDate, value: expirationDate ?? "");
  }

  static Future clearAuth() async {
    await setAuth("", "");
  }

  static Future<String> getToken() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: _prefsJwt) ?? "";
  }

  static Future<String> getExpirationDate() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: _prefsExpirationDate) ?? "";
  }
}
