import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/mock_repository.dart';
import 'state/app_state.dart';
import 'state/contacts_state.dart';
import 'state/favorites_state.dart';
import 'state/settings_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  final favoritesState = FavoritesState();
  final contactsState = ContactsState();
  final settingsState = SettingsState();
  final repository = MockRepository();

  appState.load();

  await Future.wait([
    favoritesState.load(),
    contactsState.load(),
    settingsState.load(),
    repository.preload(),
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: favoritesState),
        ChangeNotifierProvider.value(value: contactsState),
        ChangeNotifierProvider.value(value: settingsState),
        Provider.value(value: repository),
      ],
      child: const EmergencyApp(),
    ),
  );
}
