import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesState extends ChangeNotifier {
  static const _favoritesKey = 'favorite_services';

  final Set<String> _favoriteIds = {};
  late SharedPreferences _prefs;

  List<String> get favoriteIds => _favoriteIds.toList();

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs.getStringList(_favoritesKey) ?? <String>[];
    _favoriteIds
      ..clear()
      ..addAll(stored);
    notifyListeners();
  }

  bool isFavorite(String serviceId) => _favoriteIds.contains(serviceId);

  Future<void> toggleFavorite(String serviceId) async {
    if (_favoriteIds.contains(serviceId)) {
      _favoriteIds.remove(serviceId);
    } else {
      _favoriteIds.add(serviceId);
    }
    await _prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    notifyListeners();
  }

  Future<void> removeFavorite(String serviceId) async {
    _favoriteIds.remove(serviceId);
    await _prefs.setStringList(_favoritesKey, _favoriteIds.toList());
    notifyListeners();
  }
}
