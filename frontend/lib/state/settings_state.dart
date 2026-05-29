import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  static const _darkModeKey = 'dark_mode';
  static const _languageKey = 'language';
  static const _bloodGroupKey = 'blood_group';
  static const _allergiesKey = 'allergies';

  bool _darkMode = false;
  String _language = 'EN';
  String _bloodGroup = '';
  String _allergies = '';
  late SharedPreferences _prefs;

  bool get darkMode => _darkMode;
  String get language => _language;
  String get bloodGroup => _bloodGroup;
  String get allergies => _allergies;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _darkMode = _prefs.getBool(_darkModeKey) ?? false;
    _language = _prefs.getString(_languageKey) ?? 'EN';
    _bloodGroup = _prefs.getString(_bloodGroupKey) ?? '';
    _allergies = _prefs.getString(_allergiesKey) ?? '';
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    await _prefs.setBool(_darkModeKey, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    _language = value;
    await _prefs.setString(_languageKey, value);
    notifyListeners();
  }

  Future<void> setBloodGroup(String value) async {
    _bloodGroup = value;
    await _prefs.setString(_bloodGroupKey, value);
    notifyListeners();
  }

  Future<void> setAllergies(String value) async {
    _allergies = value;
    await _prefs.setString(_allergiesKey, value);
    notifyListeners();
  }
}
