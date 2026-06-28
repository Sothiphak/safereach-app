import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'neumorphic_container.dart';
import '../utils/translations.dart';

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final destinations = [
      _NavDestination(Icons.home_outlined, Icons.home, 'Home'),
      _NavDestination(Icons.near_me_outlined, Icons.near_me, 'Nearby'),
      _NavDestination(Icons.map_outlined, Icons.map, 'Map'),
      _NavDestination(Icons.people_outline, Icons.people, 'Contacts'),
      _NavDestination(Icons.settings_outlined, Icons.settings, 'Settings'),
    ];

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: NeumorphicContainer(
            borderRadius: 24,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(destinations.length, (index) {
                final dest = destinations[index];
                final isSelected = navigationShell.currentIndex == index;

                return GestureDetector(
                  onTap: () => _onTap(index),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: isDark
                                ? const Color(0xFF242B3D)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: isDark
                                    ? Colors.black26
                                    : Colors.grey.shade300,
                                offset: const Offset(1, 2),
                                blurRadius: 4,
                              ),
                            ],
                          )
                        : null,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? dest.selectedIcon : dest.icon,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                          size: 22,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dest.label.tr(context),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w900
                                : FontWeight.w600,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  _NavDestination(this.icon, this.selectedIcon, this.label);
}
