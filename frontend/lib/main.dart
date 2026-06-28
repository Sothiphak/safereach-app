import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'data/emergency_repository.dart';
import 'state/app_state.dart';
import 'state/contacts_state.dart';
import 'state/favorites_state.dart';
import 'state/settings_state.dart';
import 'state/location_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appState = AppState();
  final favoritesState = FavoritesState();
  final contactsState = ContactsState();
  final settingsState = SettingsState();
  final locationState = LocationState();
  final repository = EmergencyRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: favoritesState),
        ChangeNotifierProvider.value(value: contactsState),
        ChangeNotifierProvider.value(value: settingsState),
        ChangeNotifierProvider.value(value: locationState),
        Provider.value(value: repository),
      ],
      child: const EmergencyApp(),
    ),
  );

  appState.load();

  await Future.wait([
    favoritesState.load(),
    contactsState.load(),
    settingsState.load(),
    locationState.fetchLocation(),
    repository.preload(),
  ]);
}
