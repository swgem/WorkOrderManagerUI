import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettings {
  static const String _prefsPhoneToolsOption = "phone-tools-option";

  static Future<bool> setPhoneToolsOptions(PhoneToolsOption options) async {
    var prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_prefsPhoneToolsOption, options.name);
  }

  static Future<PhoneToolsOption> getPhoneToolsOptions() async {
    var prefs = await SharedPreferences.getInstance();
    // Initial value both in case it's never been added to SharedPrefs
    PhoneToolsOption currentOption = PhoneToolsOption.both;
    var currentOptionString = prefs.getString(_prefsPhoneToolsOption);
    for (var option in PhoneToolsOption.values) {
      if (option.name == currentOptionString) {
        currentOption = option;
      }
    }
    return currentOption;
  }
}

enum PhoneToolsOption { none, onlyWhatsapp, onlyCall, both }
