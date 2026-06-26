import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  static const _onboardingKey = 'onboarding_complete';

  bool _initialized = false;
  bool _onboardingComplete = false;
  late SharedPreferences _prefs;

  bool get isInitialized => _initialized;
  bool get onboardingComplete => _onboardingComplete;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    _onboardingComplete = _prefs.getBool(_onboardingKey) ?? false;
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingComplete = true;
    await _prefs.setBool(_onboardingKey, true);
    notifyListeners();
  }
}
