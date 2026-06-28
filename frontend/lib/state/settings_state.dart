import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState extends ChangeNotifier {
  static const englishLanguage = 'EN';
  static const khmerLanguage = 'KH';

  static const _darkModeKey = 'dark_mode';
  static const _languageKey = 'language';
  static const _bloodGroupKey = 'blood_group';
  static const _allergiesKey = 'allergies';
  static const validBloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  bool _darkMode = false;
  String _language = englishLanguage;
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
    _language = _normalizeLanguage(
      _prefs.getString(_languageKey) ?? englishLanguage,
    );
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
    _language = _normalizeLanguage(value);
    await _prefs.setString(_languageKey, _language);
    notifyListeners();
  }

  Future<bool> setBloodGroup(String value) async {
    final normalizedValue = value.trim().toUpperCase();
    if (normalizedValue.isNotEmpty &&
        !validBloodGroups.contains(normalizedValue)) {
      return false;
    }

    _bloodGroup = normalizedValue;
    await _prefs.setString(_bloodGroupKey, normalizedValue);
    notifyListeners();
    return true;
  }

  Future<void> setAllergies(String value) async {
    final trimmedValue = value.trim();
    _allergies = trimmedValue;
    await _prefs.setString(_allergiesKey, trimmedValue);
    notifyListeners();
  }

  Future<void> clearMedicalInfo() async {
    _bloodGroup = '';
    _allergies = '';
    await Future.wait([
      _prefs.remove(_bloodGroupKey),
      _prefs.remove(_allergiesKey),
    ]);
    notifyListeners();
  }

  static String _normalizeLanguage(String value) {
    return value == khmerLanguage ? khmerLanguage : englishLanguage;
  }
}
