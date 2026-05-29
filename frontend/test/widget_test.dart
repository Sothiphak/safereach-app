import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/app.dart';
import 'package:frontend/data/mock_repository.dart';
import 'package:frontend/state/app_state.dart';
import 'package:frontend/state/contacts_state.dart';
import 'package:frontend/state/favorites_state.dart';
import 'package:frontend/state/settings_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Emergency app shows SOS button', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({'onboarding_complete': true});

    final appState = AppState();
    final favoritesState = FavoritesState();
    final contactsState = ContactsState();
    final settingsState = SettingsState();
    final repository = MockRepository();

    await Future.wait([
      appState.load(),
      favoritesState.load(),
      contactsState.load(),
      settingsState.load(),
      repository.preload(),
    ]);

    await tester.pumpWidget(
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

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('SOS'), findsOneWidget);
  });
}
