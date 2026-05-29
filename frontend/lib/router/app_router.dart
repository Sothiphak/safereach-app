import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/contacts/contacts_screen.dart';
import '../features/favorites/favorites_screen.dart';
import '../features/first_aid/first_aid_screen.dart';
import '../features/home/home_screen.dart';
import '../features/map/map_screen.dart';
import '../features/nearby/nearby_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/services/service_detail_screen.dart';
import '../features/services/service_list_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';
import '../state/app_state.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  AppRouter(this.appState);

  final AppState appState;

  late final GoRouter router = GoRouter(
    initialLocation: '/splash',
    refreshListenable: appState,
    redirect: (context, state) {
      final isReady = appState.isInitialized;
      final isOnboardingComplete = appState.onboardingComplete;
      final location = state.uri.toString();

      if (!isReady) {
        return location == '/splash' ? null : '/splash';
      }

      if (!isOnboardingComplete && location != '/onboarding') {
        return '/onboarding';
      }

      if (isOnboardingComplete && (location == '/onboarding' || location == '/splash')) {
        return '/home';
      }

      if (location == '/splash') {
        return isOnboardingComplete ? '/home' : '/onboarding';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        pageBuilder: (context, state) => _fadePage(
          state,
          const SplashScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => _fadePage(
          state,
          const OnboardingScreen(),
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => _fadePage(
                  state,
                  const HomeScreen(),
                ),
                routes: [
                  GoRoute(
                    path: 'favorites',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      const FavoritesScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'first-aid',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      const FirstAidScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'services/:type',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      ServiceListScreen(
                        type: state.pathParameters['type'] ?? 'hospital',
                      ),
                    ),
                  ),
                  GoRoute(
                    path: 'service/:id',
                    pageBuilder: (context, state) => _slidePage(
                      state,
                      ServiceDetailScreen(
                        serviceId: state.pathParameters['id'] ?? '',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/nearby',
                pageBuilder: (context, state) => _fadePage(
                  state,
                  const NearbyScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                pageBuilder: (context, state) => _fadePage(
                  state,
                  const MapScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/contacts',
                pageBuilder: (context, state) => _fadePage(
                  state,
                  const ContactsScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) => _fadePage(
                  state,
                  const SettingsScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(0.1, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }
}
