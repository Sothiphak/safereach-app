import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/data/emergency_repository.dart';
import 'package:frontend/features/contacts/contacts_screen.dart';
import 'package:frontend/features/first_aid/first_aid_screen.dart';
import 'package:frontend/features/home/home_screen.dart';
import 'package:frontend/features/map/map_screen.dart';
import 'package:frontend/features/nearby/nearby_screen.dart';
import 'package:frontend/features/services/service_detail_screen.dart';
import 'package:frontend/features/settings/settings_screen.dart';
import 'package:frontend/models/emergency_branch.dart';
import 'package:frontend/models/emergency_service.dart';
import 'package:frontend/models/first_aid_tip.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/models/service_type.dart';
import 'package:frontend/state/app_state.dart';
import 'package:frontend/state/contacts_state.dart';
import 'package:frontend/state/favorites_state.dart';
import 'package:frontend/state/location_state.dart';
import 'package:frontend/state/settings_state.dart';
import 'package:frontend/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const screens = <String, Widget>{
    'Home': HomeScreen(),
    'Nearby': NearbyScreen(),
    'Map': MapScreen(),
    'Contacts': ContactsScreen(),
    'Settings': SettingsScreen(),
    'First aid': FirstAidScreen(),
    'Service detail': ServiceDetailScreen(serviceId: 'hospital_1'),
  };

  for (final entry in screens.entries) {
    testWidgets('${entry.key} fits on a narrow phone', (tester) async {
      await _setPhoneSize(tester, const Size(320, 700));
      await _pumpScreen(tester, entry.value);

      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump();
    });
  }
}

Future<void> _setPhoneSize(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<void> _pumpScreen(WidgetTester tester, Widget screen) async {
  SharedPreferences.setMockInitialValues({});

  final appState = _ReadyAppState();
  final favoritesState = FavoritesState();
  final contactsState = ContactsState();
  final settingsState = SettingsState();
  final locationState = LocationState();
  final repository = _LayoutRepository();

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
      child: MaterialApp(
        theme: AppTheme.light(settingsState.language),
        home: screen,
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 700));
}

class _ReadyAppState extends AppState {
  @override
  bool get isInitialized => true;

  @override
  bool get onboardingComplete => true;
}

class _LayoutRepository extends EmergencyRepository {
  static const _services = [
    EmergencyService(
      id: 'hospital_1',
      name: 'Calmette Hospital',
      type: ServiceType.hospital,
      phone: '+85523218878',
      address: 'Monivong Blvd, Phnom Penh',
      hours: '24/7',
      services: ['Emergency', 'Trauma', 'ICU'],
      rating: 4.6,
      reviewCount: 12,
      distanceKm: 1.2,
      openNow: true,
      latitude: 11.5625,
      longitude: 104.916,
      imageUrl: '',
      description: 'Central emergency hospital with trauma services.',
    ),
    EmergencyService(
      id: 'police_1',
      name: 'BKK1 Police Post',
      type: ServiceType.police,
      phone: '+85523227085',
      address: 'Street 360, BKK1',
      hours: '24/7',
      services: ['Patrol', 'Emergency response'],
      rating: 4.1,
      reviewCount: 8,
      distanceKm: 0.9,
      openNow: true,
      latitude: 11.5512,
      longitude: 104.9289,
      imageUrl: '',
      description: 'Local police response post.',
    ),
    EmergencyService(
      id: 'fire_1',
      name: 'Fire Department HQ',
      type: ServiceType.fire,
      phone: '+85523229890',
      address: 'Street 134, Phnom Penh',
      hours: '24/7',
      services: ['Fire response', 'Rescue'],
      rating: 4.4,
      reviewCount: 7,
      distanceKm: 2,
      openNow: true,
      latitude: 11.5674,
      longitude: 104.9194,
      imageUrl: '',
      description: 'Main fire response headquarters.',
    ),
    EmergencyService(
      id: 'ambulance_1',
      name: 'National Ambulance',
      type: ServiceType.ambulance,
      phone: '+85523219911',
      address: 'Street 118, Phnom Penh',
      hours: '24/7',
      services: ['Ambulance dispatch'],
      rating: 4.5,
      reviewCount: 10,
      distanceKm: 1.9,
      openNow: true,
      latitude: 11.5658,
      longitude: 104.9169,
      imageUrl: '',
      description: 'Citywide ambulance dispatch center.',
    ),
    EmergencyService(
      id: 'women_1',
      name: 'Women Help Hotline',
      type: ServiceType.women,
      phone: '+85512800034',
      address: 'Street 68, Phnom Penh',
      hours: '24/7',
      services: ['Hotline', 'Counseling'],
      rating: 4.7,
      reviewCount: 11,
      distanceKm: 1.5,
      openNow: true,
      latitude: 11.5722,
      longitude: 104.9158,
      imageUrl: '',
      description: 'Support hotline for women in crisis.',
    ),
    EmergencyService(
      id: 'disaster_1',
      name: 'Disaster Relief Center',
      type: ServiceType.disaster,
      phone: '+85523811111',
      address: 'Street 386, Phnom Penh',
      hours: '24/7',
      services: ['Relief coordination'],
      rating: 4.3,
      reviewCount: 9,
      distanceKm: 2.8,
      openNow: true,
      latitude: 11.5418,
      longitude: 104.9058,
      imageUrl: '',
      description: 'Relief coordination for emergencies.',
    ),
  ];

  @override
  Future<void> preload() async {}

  @override
  Future<List<EmergencyService>> getServices() async => _services;

  @override
  Future<List<EmergencyService>> getServicesByType(ServiceType type) async {
    return _services.where((service) => service.type == type).toList();
  }

  @override
  Future<EmergencyService?> getServiceById(String id) async {
    return _services.firstWhere((service) => service.id == id);
  }

  @override
  Future<List<EmergencyBranch>> getBranches() async {
    return _services
        .map(
          (service) => EmergencyBranch(
            id: service.id,
            name: service.name,
            type: service.type,
            phone: service.phone,
            address: service.address,
            latitude: service.latitude,
            longitude: service.longitude,
          ),
        )
        .toList();
  }

  @override
  Future<List<Review>> getReviews() async => const [
    Review(
      id: 'review_1',
      serviceId: 'hospital_1',
      author: 'Visitor',
      rating: 4.5,
      date: '2026-06-28',
      comment: 'Quick response and clear information.',
    ),
  ];

  @override
  Future<List<Review>> getReviewsForService(String serviceId) async {
    final reviews = await getReviews();
    return reviews.where((review) => review.serviceId == serviceId).toList();
  }

  @override
  Future<void> addReview(Review review) async {}

  @override
  Future<List<FirstAidTip>> getTips() async => const [
    FirstAidTip(
      id: 'tip_cpr',
      title: 'CPR',
      summary: 'Keep blood flowing until help arrives.',
      imageAsset: 'assets/images/first_aid_cpr.svg',
      steps: [
        'Call emergency services.',
        'Push hard and fast at the center of the chest.',
      ],
    ),
  ];
}
