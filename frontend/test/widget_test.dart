import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/app.dart';
import 'package:frontend/data/emergency_repository.dart';
import 'package:frontend/models/emergency_service.dart';
import 'package:frontend/models/service_type.dart';
import 'package:frontend/state/app_state.dart';
import 'package:frontend/state/contacts_state.dart';
import 'package:frontend/state/favorites_state.dart';
import 'package:frontend/state/location_state.dart';
import 'package:frontend/state/settings_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Emergency app shows SOS button', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final appState = _ReadyAppState();
    final favoritesState = FavoritesState();
    final contactsState = ContactsState();
    final settingsState = SettingsState();
    final locationState = LocationState();
    final repository = _TestRepository();

    await Future.wait([
      favoritesState.load(),
      contactsState.load(),
      settingsState.load(),
    ]);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>.value(value: appState),
          ChangeNotifierProvider.value(value: favoritesState),
          ChangeNotifierProvider.value(value: contactsState),
          ChangeNotifierProvider.value(value: settingsState),
          ChangeNotifierProvider.value(value: locationState),
          Provider<EmergencyRepository>.value(value: repository),
        ],
        child: const EmergencyApp(),
      ),
    );

    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('SOS'), findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}

class _ReadyAppState extends AppState {
  @override
  bool get isInitialized => true;

  @override
  bool get onboardingComplete => true;
}

class _TestRepository extends EmergencyRepository {
  @override
  Future<void> preload() async {}

  @override
  Future<List<EmergencyService>> getServices() async {
    return const [
      EmergencyService(
        id: 'test_hospital',
        name: 'Test Hospital',
        type: ServiceType.hospital,
        phone: '+85512345678',
        address: 'Test Address',
        hours: '24/7',
        services: ['Emergency'],
        rating: 4.5,
        reviewCount: 10,
        distanceKm: 1.2,
        openNow: true,
        latitude: 11.5564,
        longitude: 104.9282,
        imageUrl: '',
        description: 'Test emergency service',
      ),
    ];
  }
}
